class Book < ActiveRecord::Base
    enum status: %w(reservation now_on_sale end_of_print)
    # 数値は0から始まるけど、ハッシュ形式で指定もできる
    # enum status: {reservation: 0, now_on_sale: 1, end_of_print: 2}
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
    #validates do |book|
    #    if book.name.include?("exercise")
    #        book.errors[:name] << "I don't like exercise."
    #    end
    #end

    # コールバック　名前に"Cat"が含まれていた場合、"lovely Cat"という文字に置き換える
    # ①
    before_validation do |book|
        book.name = book.name.gsub(/Cat/) do |matched|
            "lovely #{matched}"
        end
    end
    # ②メソッドを使うやり方
    #before_validation :add_lovely_to_cat
    #def add_lovely_to_cat
    #    book.name = book.name.gsub(/Cat/) do |matched|
    #        "lovely #{matched}"
    #   end
    #end

    after_destroy do |book|
        Rails.logger.info "Book is deleted: #{book.attributes.inspect}"
    end

    # コールバックの条件指定
    def high_price?
        price >= 5000
    end

    after_destroy :if => :high_price? do |book|
        Rails.logger.warn "Book with high price is deleted: #{book.attributes.inspect}"
        Rails.logger.warn "Please check!!"
    end
end
