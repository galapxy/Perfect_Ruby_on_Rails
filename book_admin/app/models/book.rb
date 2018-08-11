class Book < ActiveRecord::Base
    scope :costly, -> { where("price > ?", 3000) }
    scope :written_about, ->(theme){ where("name like ?", "%#{theme}%") }
    # default_scope は、デフォルトで適応された状態にできる

    belongs_to :publisher

    has_many :book_authors
    has_many :authors, through: :book_authors

    # 本の名前は必ず入っていてほしい
    # 本の名前は、15文字までに収まっていて欲しい
    # 本の価格は、0以上の値になっていてほしい
    validates :name, presence: true
    validates :name, length: { maximum: 15 }
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    # 独自のバリデーション
    validates do |book|
        if book.name.include?("exercise")
            book.errors[:name] << "I don't like exercise."
end
