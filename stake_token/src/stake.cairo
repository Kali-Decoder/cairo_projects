use starknet::ContractAddress;

#[starknet::interface]
trait IERC20 {
    fn balanceOf(self: @T, owner: ContractAddress) -> u256;
    fn transfer(ref self: T, to: ContractAddress, value: u256) -> bool;
}


#[starknet::interface]
trait IStakeTrait<T> {
   fn getStakeAmount(self: @T, user_address: ContractAddress) -> u256;
    fn stake(ref self: T, amount: u256) -> bool;
    fn unstake(ref self: T) -> bool;
}


#[starknet::contract]
mod StakeContract {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        total_stake_amount:u256,
        owner:ContractAddress,
        user_stake_amounts:LegacyMap::<ContractAddress, u256>,
    }

    #[event]
    #[derive(Drop,starknet::Event)]
    enum Event{
        Staked:Staked,
        UnStaked:UnStaked
    }

    #[derive(Drop,starknet::Event)]
    struct Staked {
      #[key]
        user_address:ContractAddress,
        amount:u256,
    }

    #[derive(Drop,starknet::Event)]
    struct UnStaked {
      #[key]
        user_address:ContractAddress,
        amount:u256,
        reward:u256
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(get_caller_address());
        self.total_stake_amount.write(0);
    }

    #[external(v0)]
    impl StakeContract of super::IStakeTrait<ContractState> {
       
        fn getStakeAmount(self:@ContractState, user_address: ContractAddress) -> u256 {
            let amount = self.user_stake_amounts.read(user_address);
            amount
        }

        fn stake(ref self: ContractState, amount: u256) {
            let user_address = get_caller_address();
            let user_stake_amount = self.user_stake_amounts.read(user_address);
            let total_stake_amount = self.total_stake_amount.read();


            let erc20_contract = IERC20::new (0x06e931246fbae79e0453f780ed58a4cb2ff91f7f1c702705c3c1de41a55d9e72);
            let user_balance = erc20_contract.balanceOf(user_address);

            if user_balance >= amount {
              
                if erc20_contract.transfer(self.address, amount) {
                    self.user_stake_amounts.write(user_address, user_stake_amount + amount);
                    self.total_stake_amount.write(total_stake_amount + amount);
                    self.emit(Staked {
                        user_address,
                        amount,
                    });
                    return true;
                }
            }
            false
        }

        fn unstake(ref self: ContractState) {
            let user_address = get_caller_address();
            let user_stake_amount = self.user_stake_amounts.read(user_address);
            let total_stake_amount = self.total_stake_amount.read();
            let reward = 10; // Replace with the actual reward calculation

            // Ensure that the user has a positive staked amount
            if user_stake_amount > 0 {
                // Transfer the staked tokens and reward back to the user
                let erc20_contract = IERC20::new(0x06e931246fbae79e0453f780ed58a4cb2ff91f7f1c702705c3c1de41a55d9e72); // Replace with the actual ERC-20 contract address
                if erc20_contract.transfer(user_address, user_stake_amount + reward) {
                    self.user_stake_amounts.write(user_address, 0);
                    self.total_stake_amount.write(total_stake_amount - user_stake_amount);
                    self.emit(Unstaked {
                        user_address,
                        amount: user_stake_amount,
                        reward,
                    });
                    return true;
                }
            }
            false
        }
    }
 
}


