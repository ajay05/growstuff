class Harvest < ActiveRecord::Base
  extend FriendlyId
  friendly_id :harvest_slug, use: :slugged

  attr_accessible :crop_id, :harvested_at, :description, :owner_id,
    :quantity, :unit, :weight_quantity, :weight_unit, :plant_part, :slug

  belongs_to :crop
  belongs_to :owner, :class_name => 'Member'

  validates :quantity,
    :numericality => { :only_integer => false },
    :allow_nil => true

  UNITS_VALUES = {
    "individual" => "individual",
    "bunches" => "bunch",
    "sprigs" => "sprig",
    "handfuls" => "handful",
    "litres" => "litre",
    "pints" => "ping",
    "quarts" => "quart",
    "buckets" => "bucket",
    "baskets" => "basket",
    "bushels" => "bushel"
  }
  validates :unit, :inclusion => { :in => UNITS_VALUES.values,
    :message => "%{value} is not a valid unit" },
    :allow_nil => true,
    :allow_blank => true

  validates :weight_quantity,
    :numericality => { :only_integer => false },
    :allow_nil => true

  WEIGHT_UNITS_VALUES = {
    "kg" => "kg",
    "lb" => "lb"
  }
  validates :weight_unit, :inclusion => { :in => WEIGHT_UNITS_VALUES.values,
    :message => "%{value} is not a valid unit" },
    :allow_nil => true,
    :allow_blank => true

  after_validation :cleanup_quantities

  PLANT_PARTS = [
    'fruit',
    'flower',
    'pollen',
    'seed',
    'pod',
    'leaf',
    'stem',
    'bark',
    'bulb',
    'root',
    'tuber',
    'whole plant',
    'other'
  ]
  validates :plant_part, :inclusion => { :in => PLANT_PARTS,
    :message => "%{value} is not a valid plant part" },
    :allow_nil => true,
    :allow_blank => true

  def cleanup_quantities
    if quantity == 0
      self.quantity = nil
    end

    if quantity.blank?
      self.unit = nil
    end

    if weight_quantity == 0
      self.weight_quantity = nil
    end

    if weight_quantity.blank?
      self.weight_unit = nil
    end
  end

  def harvest_slug
    "#{owner.login_name}-#{crop}".downcase.gsub(' ', '-')
  end

end
