use starknet::ContractAddress;

#[starknet::interface]
trait IStakeTrait<T> {
    fn getStalkeAmount(self: @T, user_address: ContractAddress) -> u256;
    fn stake(ref self: T, amount: u256);
    fn unstake(ref self: T);
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
       
        fn getStalkeAmount(self:@ContractState, user_address: ContractAddress) -> u256 {
            let amount = self.user_stake_amounts.read(user_address);
            amount
        }

        fn stake(ref self: ContractState, amount: u256) {
            let user_address = get_caller_address();
            let user_stake_amount = self.user_stake_amounts.read(user_address);
            let total_stake_amount = self.total_stake_amount.read();
            self.user_stake_amounts.write(user_address, user_stake_amount + amount);
            self.total_stake_amount.write(total_stake_amount + amount);
            self.emit(Staked {
                user_address:user_address,
                amount: amount
            });
        }

        fn unstake(ref self: ContractState) {
            let user_address = get_caller_address();
            let user_stake_amount = self.user_stake_amounts.read(user_address);
            let total_stake_amount = self.total_stake_amount.read();
            let reward = 10;
            self.user_stake_amounts.write(user_address, 0);
            self.total_stake_amount.write(total_stake_amount - user_stake_amount);
            self.emit(UnStaked {
                user_address,
                amount: user_stake_amount,
                reward
            });
        }
    }
 
}
