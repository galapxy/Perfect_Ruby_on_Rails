class BooksController < ApplicationController
    # アクションコールバック onlyとかexceptとかある
    before_action :set_book, only:[:show, :edit, :update, :destroy]
    # ブロックも使える before_action do ------ end
    def show
        @book = Book.find(params[:id])
        respond_to do |format|
            format.html
            format.csv
            format.json
        end
    end

    private
    def set_book
        @book = Book.find(params[:id])
    end
end
