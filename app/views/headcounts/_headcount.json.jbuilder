json.extract! headcount,
  :id,
  :site_id,
  :recorded_by_id,
  :recorded_at,
  :capacity,
  :occupancy,
  :created_at,
  :updated_at
json.url headcount_url(headcount, format: :json)
