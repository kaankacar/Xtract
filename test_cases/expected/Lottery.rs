#![no_std]

use multiversx_sc::imports::*;

#[multiversx_sc::contract]
pub trait Lottery {
    #[storage_mapper("owner")]
    fn owner(&self) -> SingleValueMapper<ManagedAddress<Self::Api>>;

    #[storage_mapper("ticketPrice")]
    fn ticket_price(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("ticketCount")]
    fn ticket_count(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("prizePool")]
    fn prize_pool(&self) -> SingleValueMapper<BigUint<Self::Api>>;

    #[storage_mapper("lotteryOpen")]
    fn lottery_open(&self) -> SingleValueMapper<bool>;

    #[event("TicketPurchased")]
    fn ticket_purchased_event(&self, #[indexed] buyer: &ManagedAddress<Self::Api>, ticketId: &BigUint<Self::Api>);

    #[event("WinnerSelected")]
    fn winner_selected_event(&self, #[indexed] winner: &ManagedAddress<Self::Api>, prize: &BigUint<Self::Api>);

    #[event("LotteryOpened")]
    fn lottery_opened_event(&self, ticketPrice: &BigUint<Self::Api>);

    #[event("LotteryClosed")]
    fn lottery_closed_event(&self);

    #[init]
    fn init(&self) {
        owner = self.blockchain().get_caller();
        ticketPrice = BigUint::from(0u32);
        ticketCount = BigUint::from(0u32);
        prizePool = BigUint::from(0u32);
        lotteryOpen = false;
    }

    #[endpoint]
    fn open_lottery(&self, price: BigUint<Self::Api>) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(!lotteryOpen, "Already open");
        ticketPrice = price;
        lotteryOpen = true;
        self.lottery_opened_event(&price.clone());
    }

    #[endpoint]
    fn buy_ticket(&self) {
        require!(lotteryOpen, "Lottery closed");
        ticketCount = ticketCount + BigUint::from(1u32);
        prizePool = prizePool + ticketPrice;
        self.ticket_purchased_event(&self.blockchain().get_caller(), &ticketCount);
    }

    #[endpoint]
    fn close_lottery(&self) {
        require!(self.blockchain().get_caller() == owner, "Not owner");
        require!(lotteryOpen, "Already closed");
        lotteryOpen = false;
        self.lottery_closed_event();
    }

    #[view(getPrizePool)]
    fn get_prize_pool(&self) -> BigUint<Self::Api> {
        return prizePool;
    }

}