require 'rails_helper'

describe "Cars API" do

  describe 'GET /cars' do
    it 'returns a list of cars' do
      make1 = create_make
      make2 = create_make(name: 'Ford')
      red_car = create_car(color: "red", doors: "4", purchased_on: "1973-10-04", make_id: make1.id)
      blue_car = create_car(color: "blue", doors: "2", purchased_on: "2012-01-24", make_id: make2.id)

      get '/cars', {}, {'Accept' => 'application/json'}

      expected_response = {
        "_links" => {
          "self" => {
            "href" => cars_path
          }
        },
        "_embedded" => {
          "cars" => [
            {
              "_links" => {
                "self" => {
                  "href" => car_path(red_car)
                },
                "make" => {
                  "href" => "/makes/#{red_car.make_id}"
                }
              },
              "id" => red_car.id,
              "color" => red_car.color,
              "doors" => red_car.doors,
              "purchased_on" => "1973-10-04"
            },
            {
              "_links" => {
                "self" => {
                  "href" => car_path(blue_car)
                },
                "make" => {
                  "href" => "/makes/#{blue_car.make_id}"
                }
              },
              "id" => blue_car.id,
              "color" => blue_car.color,
              "doors" => blue_car.doors,
              "purchased_on" => "2012-01-24"
            }
          ]
        }
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)
    end

    it 'will return a car if it exists' do
      make1 = create_make
      red_car = create_car(color: "red", doors: "4", purchased_on: "1973-10-04", make_id: make1.id)

      get "/cars/#{red_car.id}", {}, {'Accept' => 'application/json'}
      expected_response = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{red_car.id}"
          },
          "make" => {
            "href" => "/makes/#{red_car.make_id}"
          }
        },
        "id" => red_car.id,
        "color" => red_car.color,
        "doors" => red_car.doors,
        "purchased_on" => "1973-10-04"
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)
    end

    it 'will return a 404 if the car does not exist' do
      get "/cars/89034", {}, {'Accept' => 'application/json'}
      expected_response = {}
      expect(response.code.to_i).to eq 404
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
  end
end


