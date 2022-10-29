class Quote < ApplicationRecord
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # Same as : after_create_commit -> { broadcast_prepend_to "quotes" }
  # Pas besoin de partial, locals et target car avec les conventions de nommage,
  # les 3 attributs savent que c'est "quote" dont on parle comme on est dans le model "Quote"
  ## after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }

  # le later_to est pour rendre la partie diffusion asynchrone en tâches d'arrière plan
  # Cette méthode sera préférée pour des raisons de performances
  ## after_update_commit -> { broadcast_prepend_later_to "quotes" }

  # le later_to ne peut se faire sur une suppression
  ## after_destroy_commit -> { broadcast_remove_to "quotes" }

  # Ces trois méthodes sont codées par rails avec une seule ligne
  broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend
end
