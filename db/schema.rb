# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_16_140605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colors", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "product_colors", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "colors_id"
    t.index ["colors_id"], name: "index_product_colors_on_colors_id"
    t.index ["product_id"], name: "index_product_colors_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "code", null: false
  end

  create_table "supplier_informations", force: :cascade do |t|
    t.bigint "product_information_id"
    t.bigint "supplier_id"
    t.integer "in_stock_count", null: false
    t.index ["product_information_id"], name: "index_supplier_informations_on_product_information_id"
    t.index ["supplier_id"], name: "index_supplier_informations_on_supplier_id"
  end

  create_table "supplier_regions", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "region_id"
    t.integer "delivery_day_count", null: false
    t.index ["region_id"], name: "index_supplier_regions_on_region_id"
    t.index ["supplier_id"], name: "index_supplier_regions_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name", null: false
  end

end
