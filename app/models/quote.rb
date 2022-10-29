class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # Same as : after_create_commit -> { broadcast_prepend_to "quotes" }
  # Pas besoin de partial, locals et target car avec les conventions de nommage,
  # les 3 attributs savent que c'est "quote" dont on parle comme on est dans le model "Quote"
  after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }

  after_update_commit -> { broadcast_prepend_to "quotes" }
end
