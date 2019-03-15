class MedicalHistory < ApplicationRecord
    belongs_to :user


    def self.list_in_wait
        MedicalHistory.where(state: 'in_wait')
    end

    def reject
        self.state = "rejected"
    end

    def accept
        self.state = "accepted"
    end
end
