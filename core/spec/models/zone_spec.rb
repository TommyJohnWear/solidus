require 'spec_helper'

describe Spree::Zone do
  let(:country) { Factory :country }
  let(:state) { Factory :state }
  let(:zone) { Factory :zone }

  context 'factory' do
    #let(:zone){ Factory :zone }

    it "should set zone members correctly" do
      zone.zone_members.count.should == 1
    end
  end

  context "#destroy" do
    before { zone.destroy }
    it "should destroy all zone members" do
      zone.zone_members.count.should == 0
    end
  end

  context "#country_list" do
    context "given a zone of countries" do
      it 'should return a list of countries' do
        zone.zone_members = [Spree::ZoneMember.create(:zoneable => country)]
        zone.country_list.should == [country]
      end
    end
    
    context "given a zone of states" do
      it 'should return a list of countries that states belongs to' do
        zone.zone_members = [Spree::ZoneMember.create(:zoneable => state)]
        zone.country_list.should == [state.country]
      end
    end

    context "given a zone of zones" do
      it 'should return a list of countries belong to the children zones' do
        sub_zone = Factory.build(:zone, :zone_members => [Spree::ZoneMember.create(:zoneable => country)])
        zone.zone_members = [Spree::ZoneMember.create(:zoneable => sub_zone)]
        zone.country_list.should == [country]
      end
    end
  end
end
