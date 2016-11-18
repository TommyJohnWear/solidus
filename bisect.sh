#!/bin/sh

set -e

# Switching Gemfile
set_gemfile(){
  echo "Switching Gemfile..."
  export BUNDLE_GEMFILE="`pwd`/Gemfile"
}

# Target postgresql. Override with: `DB=sqlite bash build.sh`
export DB=${DB:-mysql}

echo "Clean"
bundle exec rake clean

# Spree defaults
echo "Setup Spree defaults and creating test application..."
bundle check || bundle update --quiet

# Spree API
echo "**************************************"
echo "* Setup Spree API and running RSpec..."
echo "**************************************"
cd api; set_gemfile; bundle update

# Spree Backend
echo "******************************************"
echo "* Setup Spree Backend and running RSpec..."
echo "******************************************"
cd ../backend; set_gemfile; bundle update

# Spree Core
echo "***************************************"
echo "* Setup Spree Core and running RSpec..."
echo "***************************************"
cd ../core; set_gemfile; bundle update

# Spree Frontend
echo "*******************************************"
echo "* Setup Spree Frontend and running RSpec..."
echo "*******************************************"
cd ../frontend; set_gemfile; bundle update

# Spree Sample
echo "*****************************************"
echo "* Setup Spree Sample and running RSpec..."
echo "*****************************************"
cd ../sample; set_gemfile; bundle update

echo "*****************************************"
echo "* Run core order_spec "
echo "*****************************************"
cd ../core; set_gemfile; bundle exec rake test_app; bundle exec rspec spec/models/spree/order_spec.rb
