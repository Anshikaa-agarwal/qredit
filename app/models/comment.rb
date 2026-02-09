class Comment < ApplicationRecord
    # associations
    belongs_to :user
    belongs_to :commentable, polymorphic: true

    # validations
    validates :content, presence: true
end
