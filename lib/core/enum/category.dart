import 'dart:math';

import 'package:flutter/material.dart';

enum Category {
  bills('Bills', Icons.receipt_outlined, 'bills'),
  books('Books', Icons.book_outlined, 'books'),
  cableTV('Cable TV', Icons.live_tv_outlined, 'cable_tv'),
  cafe('Cafe', Icons.local_cafe_outlined, 'cafe'),
  cashWithdrawal('Cash withdrawal', Icons.account_balance_wallet_outlined,
      'cash_withdrawal'),
  charityDonations('Charity & Donations', Icons.volunteer_activism_outlined,
      'charity_donations'),
  children('Children', Icons.child_friendly_outlined, 'children'),
  concert('Concert', Icons.music_note_outlined, 'concert'),
  cost('Cost', Icons.attach_money_outlined, 'cost'),
  creditCard('Credit card', Icons.credit_card_outlined, 'credit_card'),
  debt('Debt', Icons.money_off_csred_outlined, 'debt'),
  drugsMedicine('Drugs/Medicine', Icons.medication_outlined, 'drugs_medicine'),
  education('Education', Icons.school_outlined, 'education'),
  electricity('Electricity', Icons.electric_bolt_outlined, 'electricity'),
  emergencyFund(
      'Emergency fund', Icons.local_fire_department_outlined, 'emergency_fund'),
  entertainment('Entertainment', Icons.celebration_outlined, 'entertainment'),
  family('Family', Icons.family_restroom_outlined, 'family'),
  fashion('Fashion', Icons.checkroom_outlined, 'fashion'),
  foodsDrinks('Foods & Drinks', Icons.restaurant_menu_outlined, 'foods_drinks'),
  funeral('Funeral', Icons.church_outlined, 'funeral'),
  gadgetElectronics('Gadget & electronics', Icons.devices_other_outlined,
      'gadget_electronics'),
  games('Games', Icons.sports_esports_outlined, 'games'),
  gas('Gas', Icons.local_gas_station_outlined, 'gas'),
  gasoline('Gasoline', Icons.local_gas_station_outlined, 'gasoline'),
  gifts('Gifts', Icons.card_giftcard_outlined, 'gifts'),
  groceries('Groceries', Icons.shopping_basket_outlined, 'groceries'),
  gymFitness('Gym/Fitness', Icons.fitness_center_outlined, 'gym_fitness'),
  hangOut('Hang out', Icons.group_outlined, 'hang_out'),
  healthcare('Healthcare', Icons.medical_services_outlined, 'healthcare'),
  hobby('Hobby', Icons.sports_outlined, 'hobby'),
  houseApartment('House/Apartment', Icons.home_outlined, 'house_apartment'),
  householdAssistant('Household assistant', Icons.cleaning_services_outlined,
      'household_assistant'),
  insurance('Insurance', Icons.verified_user_outlined, 'insurance'),
  internet('Internet', Icons.wifi_outlined, 'internet'),
  investment('Investment', Icons.trending_up_outlined, 'investment'),
  interest('Interest', Icons.local_florist_rounded, 'interest'),
  landline('Landline', Icons.phone_outlined, 'landline'),
  laundry('Laundry', Icons.local_laundry_service_outlined, 'laundry'),
  loans('Loans', Icons.attach_money_outlined, 'loans'),
  maintenanceFee('Maintenance fee', Icons.build_outlined, 'maintenance_fee'),
  medicalFee('Medical fee', Icons.local_hospital_outlined, 'medical_fee'),
  mobileData('Mobile & Data', Icons.phone_android_outlined, 'mobile_data'),
  mortgage('Mortgage', Icons.real_estate_agent_outlined, 'mortgage'),
  moviesMusics('Movies/Musics', Icons.movie_outlined, 'movies_musics'),
  others('Others', Icons.more_horiz, 'others'),
  outgoing('Outgoing', Icons.logout_outlined, 'outgoing'),
  parent('Parent', Icons.supervisor_account_outlined, 'parent'),
  parkingFee('Parking fee', Icons.local_parking_outlined, 'parking_fee'),
  pension('Pension', Icons.payments_outlined, 'pension'),
  personalCare('Personal care', Icons.spa_outlined, 'personal_care'),
  pet('Pet', Icons.pets_outlined, 'pet'),
  publicTransport('Public transport', Icons.tram_outlined, 'public_transport'),
  renovation('Renovation', Icons.construction_outlined, 'renovation'),
  rent('Rent', Icons.house_outlined, 'rent'),
  restaurant('Restaurant', Icons.restaurant_outlined, 'restaurant'),
  savings('Savings', Icons.savings_outlined, 'savings'),
  settlement('Settlement', Icons.handshake_outlined, 'settlement'),
  shopping('Shopping', Icons.shopping_cart_outlined, 'shopping'),
  socialEvents('Social events', Icons.people_outlined, 'social_events'),
  sports('Sports', Icons.sports_outlined, 'sports'),
  streamingServices(
      'Streaming services', Icons.subscriptions_outlined, 'streaming_services'),
  subscriptions('Subscriptions', Icons.subscriptions_outlined, 'subscriptions'),
  takeOuts('Take outs', Icons.fastfood_outlined, 'take_outs'),
  tapCash('TapCash', Icons.credit_card_outlined, 'tap_cash'),
  taxes('Taxes', Icons.receipt_long_outlined, 'taxes'),
  taxiOjol('Taxi/Ojol', Icons.local_taxi_outlined, 'taxi_ojol'),
  topUp('Top up', Icons.upload_outlined, 'top_up'),
  topUpCard('Top up card', Icons.credit_card_outlined, 'top_up_card'),
  transportation(
      'Transportation', Icons.directions_bus_outlined, 'transportation'),
  travelFares('Travel fares', Icons.flight_takeoff_outlined, 'travel_fares'),
  tuitionFee('Tuition Fee', Icons.attach_money_outlined, 'tuition_fee'),
  vacation('Vacation', Icons.beach_access_outlined, 'vacation'),
  vehicle('Vehicle', Icons.directions_car_outlined, 'vehicle'),
  vehicleMaintenance(
      'Vehicle maintenance', Icons.car_repair_outlined, 'vehicle_maintenance'),
  water('Water', Icons.water_drop_outlined, 'water'),
  wedding('Wedding', Icons.celebration_outlined, 'wedding');

  final String displayName;
  final IconData icon;
  final String iconKey;

  const Category(this.displayName, this.icon, this.iconKey);

  static Category fromValue(String value) {
    for (final category in Category.values) {
      if (category.iconKey == value) {
        return category;
      }
    }

    for (final category in Category.values) {
      if (category.displayName == value) {
        return category;
      }
    }
    // Default to 'others' if no match found
    return Category.others;
  }

  /// Returns a random Category from the Category enum
  static Category getRandomCategory() {
    final categories = Category.getUniqueCategoriesByIcon();
    final random = Random();
    final randomIndex = random.nextInt(categories.length);
    return categories[randomIndex];
  }

  /// Returns a list of all categories
  static List<Category> getCategories() {
    return List<Category>.from(Category.values);
  }

  /// Returns a list of unique categories based on their icons
  /// Categories with duplicate icons are filtered out, keeping only the first occurrence
  static List<Category> getUniqueCategoriesByIcon() {
    final seenIcons = <int>{};
    final uniqueCategories = <Category>[];

    for (final category in Category.values) {
      // IconData's hashCode is based on the icon data
      if (!seenIcons.contains(category.icon.hashCode)) {
        seenIcons.add(category.icon.hashCode);
        uniqueCategories.add(category);
      }
    }

    return uniqueCategories;
  }

  /// Returns a list of CategoryGroup objects, structuring the flat enum
  /// into groups mirroring the user's visual design.
  static List<CategoryGroup> getGroupedCategories() {
    final List<CategoryGroup> groups = [];
    final Map<String, List<Category>> categoryMap = {};

    // Helper to add a category to the correct group
    void addToGroup(String groupName, Category category) {
      categoryMap.putIfAbsent(groupName, () => []).add(category);
    }

    // Map each flat enum member to its group based on the visual structure in the images.
    for (final category in Category.values) {
      switch (category) {
        // --- PAYMENTS (Top-ups, Digital Cash) ---
        case Category.topUp:
        case Category.topUpCard:
        case Category.tapCash:
          addToGroup('Payments & Wallets', category);
          break;

        // --- FOODS & DINING ---
        case Category.foodsDrinks:
        case Category.cafe:
        case Category.restaurant:
        case Category.takeOuts:
        case Category.groceries:
          addToGroup('Foods & Dining', category);
          break;

        // --- SHOPPING (Goods & Non-Food Items) ---
        case Category.shopping:
        case Category.fashion:
        case Category.gadgetElectronics:
          addToGroup('Shopping', category);
          break;

        // --- TRANSPORTATION ---
        case Category.transportation:
        case Category.travelFares:
        case Category.vehicleMaintenance:
        case Category.gasoline:
        case Category.parkingFee:
        case Category.publicTransport:
        case Category.taxiOjol:
        case Category.vehicle:
          addToGroup('Transportation', category);
          break;

        // --- BILLS & UTILITIES ---
        case Category.bills:
        case Category.cableTV:
        case Category.creditCard:
        case Category.electricity:
        case Category.gas:
        case Category.insurance:
        case Category.internet:
        case Category.landline:
        case Category.maintenanceFee:
        case Category.mobileData:
          addToGroup('Bills & Utilities', category);
          break;

        // --- HOME & HOUSEHOLD ---
        case Category.rent:
        case Category.subscriptions:
        case Category.water:
        case Category.householdAssistant:
        case Category.laundry:
        case Category.renovation:
        case Category.houseApartment:
          addToGroup('Home & Household', category);
          break;

        // --- DEBT & LOANS ---
        case Category.debt:
        case Category.loans:
        case Category.mortgage:
          addToGroup('Debt & Loans', category);
          break;

        // --- SAVINGS & INVESTMENT ---
        case Category.savings:
        case Category.investment:
        case Category.emergencyFund:
        case Category.pension:
        case Category.interest:
          addToGroup('Savings & Investment', category);
          break;

        // --- HEALTHCARE & WELLNESS ---
        case Category.healthcare:
        case Category.drugsMedicine:
        case Category.gymFitness:
        case Category.medicalFee:
        case Category.personalCare:
        case Category.sports:
        case Category.pet:
          addToGroup('Healthcare & Wellness', category);
          break;

        // --- EDUCATION ---
        case Category.education:
        case Category.books:
        case Category.tuitionFee:
          addToGroup('Education', category);
          break;

        // --- ENTERTAINMENT & LIFESTYLE ---
        case Category.entertainment:
        case Category.concert:
        case Category.games:
        case Category.hangOut:
        case Category.hobby:
        case Category.moviesMusics:
        case Category.streamingServices:
        case Category.vacation:
        case Category.wedding:
          addToGroup('Entertainment & Lifestyle', category);
          break;

        // --- FAMILY & SOCIAL ---
        case Category.children:
        case Category.family:
        case Category.parent:
        case Category.socialEvents:
        case Category.funeral:
        case Category.gifts:
          addToGroup('Family & Social', category);
          break;

        // --- OTHERS & MISC. ---
        case Category.others:
        case Category.cashWithdrawal:
        case Category.cost:
        case Category.outgoing:
        case Category.settlement:
        case Category.taxes:
        case Category.charityDonations:
          addToGroup('Others & Misc.', category);
          break;
      }
    }

    // Convert the map into the final list of CategoryGroup objects
    categoryMap.forEach((title, categories) {
      // Sort categories within the group alphabetically by display name for consistency
      categories.sort((a, b) => a.displayName.compareTo(b.displayName));
      groups.add(CategoryGroup(title: title, categories: categories));
    });

    // Optional: Sort the groups themselves alphabetically by title
    groups.sort((a, b) => a.title.compareTo(b.title));

    return groups;
  }
}

/// A class to hold a group of related Category enum values,
/// representing a section header in the UI.
class CategoryGroup {
  final String title;
  final List<Category> categories;

  CategoryGroup({required this.title, required this.categories});
}
