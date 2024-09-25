module MyModule::CommunityAchievements {

    use aptos_framework::signer;
    use std::vector;

    /// Struct representing a contribution by a participant.
    struct Contribution has copy, drop, store {
        contributor: address,
        amount: u64,
    }

    /// Resource representing the community achievement.
     struct AchievementToken has store, key {
        owner: address,
        achievement_id: u64,
        description: vector<u8>,
        total_contribution: u64,
        contributions: vector<Contribution>,
    }

    /// Function to mint a new community achievement token.
    public fun mint_achievement(owner: &signer, achievement_id: u64, description: vector<u8>) {
        let token = AchievementToken {
            owner: signer::address_of(owner),
            achievement_id,
            description,
            total_contribution: 0,
            contributions: vector::empty<Contribution>(),
        };
        move_to(owner, token);
    }

    /// Function for participants to contribute towards the community goal.
    public fun contribute(owner: address, amount: u64, participant: &signer) acquires AchievementToken {
        let token = borrow_global_mut<AchievementToken>(owner);
        let contribution = Contribution {
            contributor: signer::address_of(participant),
            amount,
        };
        vector::push_back(&mut token.contributions, contribution);
        token.total_contribution = token.total_contribution + amount;
    }
}
