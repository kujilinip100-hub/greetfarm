class LanguageService {
  static String currentLang = "en"; // en / ta / si

  static final Map<String, Map<String, String>> _translations = {
    // Login / Register
    "welcome": {"en": "Welcome to GreetFarm", "ta": "GreetFarm-க்கு வரவேற்கிறோம்", "si": "GreetFarm වෙත සාදරයෙන් පිළිගනිමු"},
    "tagline": {"en": "Farmer to Customer, Directly", "ta": "விவசாயியிடமிருந்து நேரடியாக நுகர்வோருக்கு", "si": "ගොවියාගෙන් කෙලින්ම පාරිභෝගිකයාට"},
    "username": {"en": "Username", "ta": "பயனர்பெயர்", "si": "පරිශීලක නාමය"},
    "password": {"en": "Password", "ta": "கடவுச்சொல்", "si": "මුරපදය"},
    "login": {"en": "LOGIN", "ta": "உள்நுழைய", "si": "පිවිසෙන්න"},
    "no_account": {"en": "Don't have an account? ", "ta": "கணக்கு இல்லையா? ", "si": "ගිණුමක් නැද්ද? "},
    "register": {"en": "Register", "ta": "பதிவு செய்யவும்", "si": "ලියාපදිංචි වන්න"},
    "create_account": {"en": "Create Account", "ta": "கணக்கை உருவாக்கவும்", "si": "ගිණුමක් සාදන්න"},
    "full_name": {"en": "Full Name", "ta": "முழுப்பெயர்", "si": "සම්පූර්ණ නම"},
    "email": {"en": "Email", "ta": "மின்னஞ்சல்", "si": "විද්‍යුත් තැපෑල"},
    "phone": {"en": "Phone Number", "ta": "தொலைபேசி எண்", "si": "දුරකථන අංකය"},
    "location": {"en": "Location", "ta": "இருப்பிடம்", "si": "ස්ථානය"},
    "register_as": {"en": "Register As", "ta": "பதிவு செய்யுங்கள்", "si": "ලෙස ලියාපදිංචි වන්න"},
    "farmer": {"en": "Farmer", "ta": "விவசாயி", "si": "ගොවියා"},
    "customer": {"en": "Customer", "ta": "வாடிக்கையாளர்", "si": "පාරිභෝගිකයා"},
    "already_account": {"en": "Already have an account? ", "ta": "ஏற்கனவே கணக்கு உள்ளதா? ", "si": "දැනටමත් ගිණුමක් තිබේද? "},
    "login_link": {"en": "Login", "ta": "உள்நுழைய", "si": "පිවිසෙන්න"},

    // Dashboard
    "welcome_farmer": {"en": "Welcome Farmer", "ta": "வரவேற்கிறோம் விவசாயி", "si": "සාදරයෙන් පිළිගනිමු ගොවියා"},
    "add_product": {"en": "Add Product", "ta": "பொருள் சேர்க்க", "si": "නිෂ්පාදනය එකතු කරන්න"},
    "my_products": {"en": "My Products", "ta": "என் பொருட்கள்", "si": "මගේ නිෂ්පාදන"},
    "view_orders": {"en": "View Orders", "ta": "ஆர்டர்களைப் பார்க்க", "si": "ඇණවුම් බලන්න"},
    "harvest_calendar": {"en": "Harvest Calendar", "ta": "அறுவடை நாள்காட்டி", "si": "අස්වනු දින දර්ශනය"},
    "qr_scanner": {"en": "QR Scanner", "ta": "QR ஸ்கேனர்", "si": "QR ස්කෑනරය"},
    "profile": {"en": "Profile", "ta": "சுயவிவரம்", "si": "පැතිකඩ"},
    "demand_prediction": {"en": "Demand Prediction", "ta": "தேவை முன்னறிவிப்பு", "si": "ඉල්ලුම් අනාවැකිය"},
    "sales_analytics": {"en": "Sales Analytics", "ta": "விற்பனை பகுப்பாய்வு", "si": "විකුණුම් විශ්ලේෂණ"},
    "logout": {"en": "Logout", "ta": "வெளியேறு", "si": "පිටවීම"},
    "browse_products": {"en": "Browse Products", "ta": "பொருட்களை பார்வையிடவும்", "si": "නිෂ්පාදන පිරික්සන්න"},
    "my_orders": {"en": "My Orders", "ta": "என் ஆர்டர்கள்", "si": "මගේ ඇණවුම්"},
    "my_spending": {"en": "My Spending", "ta": "என் செலவு", "si": "මගේ වැය කිරීම"},
    "nearby_farmers": {"en": "Nearby Farmers", "ta": "அருகிலுள்ள விவசாயிகள்", "si": "අසල්වාසී ගොවීන්"},
    "fresh_veg_desc": {"en": "Fresh vegetables from local farmers", "ta": "உள்ளூர் விவசாயிகளிடமிருந்து புதிய காய்கறிகள்", "si": "දේශීය ගොවීන්ගෙන් නැවුම් එළවළු"},

    // Add Product
    "add_product_title": {"en": "Add Product", "ta": "பொருள் சேர்க்க", "si": "නිෂ්පාදනය එකතු කරන්න"},
    "product_name": {"en": "Product Name", "ta": "பொருளின் பெயர்", "si": "නිෂ්පාදන නම"},
    "category": {"en": "Category", "ta": "வகை", "si": "වර්ගය"},
    "price": {"en": "Price (Rs)", "ta": "விலை (ரூ)", "si": "මිල (රු)"},
    "quantity": {"en": "Quantity (Kg)", "ta": "அளவு (கிலோ)", "si": "ප්‍රමාණය (kg)"},
    "harvest_date": {"en": "Harvest Date", "ta": "அறுவடை தேதி", "si": "අස්වනු දිනය"},
    "distance": {"en": "Distance from Collection Point (Km)", "ta": "சேகரிப்பு இடத்திலிருந்து தூரம் (கி.மீ)", "si": "එකතු කිරීමේ ස්ථානයේ සිට දුර (km)"},
    "description": {"en": "Product Description (Optional)", "ta": "பொருள் விவரம் (விருப்பம்)", "si": "නිෂ්පාදන විස්තරය (විකල්ප)"},
    "choose_image": {"en": "Choose Product Image", "ta": "பொருளின் படத்தைத் தேர்வு செய்யவும்", "si": "නිෂ්පාදන රූපය තෝරන්න"},
    "add_product_btn": {"en": "Add Product", "ta": "பொருளைச் சேர்க்க", "si": "නිෂ්පාදනය එකතු කරන්න"},
    "adding": {"en": "Adding...", "ta": "சேர்க்கப்படுகிறது...", "si": "එකතු කරමින්..."},
    "list_new_product": {"en": "List a new product for customers to discover", "ta": "வாடிக்கையாளர்கள் காண புதிய பொருளைப் பதிவு செய்யவும்", "si": "පාරිභෝගිකයින්ට සොයා ගැනීමට නව නිෂ්පාදනයක් ලැයිස්තුගත කරන්න"},

    // Browse Products
    "fresh_products": {"en": "Fresh Products", "ta": "புதிய பொருட்கள்", "si": "නැවුම් නිෂ්පාදන"},
    "search_products": {"en": "Search Products...", "ta": "பொருட்களைத் தேடவும்...", "si": "නිෂ්පාදන සොයන්න..."},
    "filter_distance": {"en": "Filter by Distance", "ta": "தூரம் மூலம் வடிகட்டவும்", "si": "දුර අනුව පෙරහන් කරන්න"},
    "all_distances": {"en": "All Distances", "ta": "அனைத்து தூரங்களும்", "si": "සියලුම දුර"},
    "no_products_found": {"en": "No products found in this range", "ta": "இந்த தூரத்தில் பொருட்கள் இல்லை", "si": "මෙම පරාසය තුළ නිෂ්පාදන හමු නොවුණි"},
    "kg_available": {"en": "Kg available", "ta": "கிலோ கிடைக்கிறது", "si": "kg ලබා ගත හැක"},

    // Reserve Product
    "reserve_product_title": {"en": "Reserve Product", "ta": "பொருளை முன்பதிவு செய்யவும்", "si": "නිෂ්පාදනය වෙන් කරන්න"},
    "available_qty": {"en": "Available Quantity", "ta": "கிடைக்கும் அளவு", "si": "තිබෙන ප්‍රමාණය"},
    "select_qty": {"en": "Select Quantity (Kg)", "ta": "அளவைத் தேர்வு செய்யவும் (கிலோ)", "si": "ප්‍රමාණය තෝරන්න (kg)"},
    "not_enough_stock": {"en": "Not enough stock available", "ta": "போதிய இருப்பு இல்லை", "si": "ප්‍රමාණවත් තොග නොමැත"},

    // Harvest Calendar
    "harvest_calendar_title": {"en": "Harvest Calendar", "ta": "அறுவடை நாள்காட்டி", "si": "අස්වනු දින දර්ශනය"},
    "no_harvest_scheduled": {"en": "No harvest scheduled on this date.", "ta": "இந்த தேதியில் அறுவடை இல்லை.", "si": "මෙම දිනයේ අස්වැන්නක් නොමැත."},
    "low_stock": {"en": "Low Stock (\u22642 Kg)", "ta": "குறைந்த இருப்பு (\u22642 கிலோ)", "si": "අඩු තොග (\u22642 kg)"},
    "limited_stock": {"en": "Limited (\u22645 Kg)", "ta": "வரையறுக்கப்பட்டது (\u22645 கிலோ)", "si": "සීමිත (\u22645 kg)"},
    "good_stock": {"en": "Good Stock", "ta": "நல்ல இருப்பு", "si": "හොඳ තොග"},

    // My Products
    "my_products_title": {"en": "My Products", "ta": "என் பொருட்கள்", "si": "මගේ නිෂ්පාදන"},
    "no_products_added": {"en": "No Products Added Yet 🌾\nTap 'Add Product' to get started", "ta": "இன்னும் பொருட்கள் சேர்க்கப்படவில்லை 🌾\n'பொருள் சேர்க்க' தட்டவும்", "si": "තවම නිෂ්පාදන එකතු කර නැත 🌾\n'නිෂ්පාදනය එකතු කරන්න' ඔබන්න"},
    "delete_product_title": {"en": "Delete Product", "ta": "பொருளை நீக்கு", "si": "නිෂ්පාදනය මකන්න"},
    "cancel": {"en": "Cancel", "ta": "ரத்து செய்", "si": "අවලංගු කරන්න"},
    "delete": {"en": "Delete", "ta": "நீக்கு", "si": "මකන්න"},

    // View Orders (Farmer)
    "view_orders_title": {"en": "View Orders", "ta": "ஆர்டர்களைப் பார்க்க", "si": "ඇණවුම් බලන්න"},
    "no_orders_yet": {"en": "No Orders Yet", "ta": "இன்னும் ஆர்டர்கள் இல்லை", "si": "තවම ඇණවුම් නැත"},

    // Status labels
    "status_pending": {"en": "Pending", "ta": "நிலுவையில்", "si": "පොරොත්තුවෙන්"},
    "status_ready": {"en": "Ready", "ta": "தயார்", "si": "සූදානම්"},
    "status_collected": {"en": "Collected", "ta": "பெறப்பட்டது", "si": "එකතු කරන ලදී"},

    // Profile
    "farmer_profile_title": {"en": "Farmer Profile", "ta": "விவசாயி சுயவிவரம்", "si": "ගොවි පැතිකඩ"},
    "customer_profile_title": {"en": "Customer Profile", "ta": "வாடிக்கையாளர் சுயவிவரம்", "si": "පාරිභෝගික පැතිකඩ"},
    "name": {"en": "Name", "ta": "பெயர்", "si": "නම"},
    "phone_number": {"en": "Phone Number", "ta": "தொலைபேசி எண்", "si": "දුරකථන අංකය"},
    "location_label": {"en": "Location", "ta": "இருப்பிடம்", "si": "ස්ථානය"},
    "nearby_collection_area": {"en": "Nearby Collection Area", "ta": "அருகிலுள்ள சேகரிப்பு பகுதி", "si": "අසල් එකතු කිරීමේ ප්‍රදේශය"},
    "profile_updated": {"en": "Profile updated!", "ta": "சுயவிவரம் புதுப்பிக்கப்பட்டது!", "si": "පැතිකඩ යාවත්කාලීන කරන ලදී!"},

    // Product Details
    "product_details_title": {"en": "Product Details", "ta": "பொருள் விவரங்கள்", "si": "නිෂ්පාදන විස්තර"},
    "sold_by": {"en": "Sold by", "ta": "விற்பவர்", "si": "විකුණන්නා"},
    "price_label": {"en": "Price", "ta": "விலை", "si": "මිල"},
    "available_label": {"en": "Available", "ta": "கிடைக்கும்", "si": "තිබේ"},
    "farmers_location": {"en": "Farmer's Location", "ta": "விவசாயியின் இருப்பிடம்", "si": "ගොවියාගේ ස්ථානය"},
    "approx_away": {"en": "Approximately", "ta": "தோராயமாக", "si": "දළ වශයෙන්"},
    "km_away": {"en": "Km away", "ta": "கி.மீ தொலைவில்", "si": "km දුරින්"},
    "tap_view_map": {"en": "Tap to view on map", "ta": "வரைபடத்தில் பார்க்க தட்டவும்", "si": "සිතියමේ බැලීමට ඔබන්න"},
    "out_of_stock": {"en": "Out of Stock", "ta": "கையிருப்பு இல்லை", "si": "තොග නැත"},

    // Collection Point
    "collection_point_title": {"en": "Collection Point", "ta": "சேகரிப்பு இடம்", "si": "එකතු කිරීමේ ස්ථානය"},
    "select_collection_point": {"en": "Select Collection Point", "ta": "சேகரிப்பு இடத்தைத் தேர்வு செய்யவும்", "si": "එකතු කිරීමේ ස්ථානය තෝරන්න"},
    "continue_btn": {"en": "Continue", "ta": "தொடரவும்", "si": "ඉදිරියට"},

    // Collection QR
    "collection_qr_title": {"en": "Collection QR", "ta": "சேகரிப்பு QR", "si": "එකතු කිරීමේ QR"},
    "reservation_confirmed": {"en": "Reservation Confirmed", "ta": "முன்பதிவு உறுதி செய்யப்பட்டது", "si": "වෙන්කිරීම තහවුරු කරන ලදී"},
    "show_qr_at_point": {"en": "Show this QR at Collection Point", "ta": "இந்த QR-ஐ சேகரிப்பு இடத்தில் காட்டவும்", "si": "මෙම QR එකතු කිරීමේ ස්ථානයේ පෙන්වන්න"},
    "order_id_label": {"en": "Order ID", "ta": "ஆர்டர் எண்", "si": "ඇණවුම් අංකය"},
    "product_label": {"en": "Product", "ta": "பொருள்", "si": "නිෂ්පාදනය"},
    "collection_point_label": {"en": "Collection Point", "ta": "சேகரிப்பு இடம்", "si": "එකතු කිරීමේ ස්ථානය"},
    "thank_you_farmers": {"en": "Thank you for supporting local farmers!", "ta": "உள்ளூர் விவசாயிகளை ஆதரித்ததற்கு நன்றி!", "si": "දේශීය ගොවීන්ට සහාය වීම ගැන ස්තුතියි!"},
    "see_you_again": {"en": "See you again soon on GreetFarm 🌾", "ta": "GreetFarm-ல் மீண்டும் சந்திப்போம் 🌾", "si": "GreetFarm හි නැවත හමුවෙමු 🌾"},
    "back_to_dashboard": {"en": "Back to Dashboard", "ta": "டாஷ்போர்டுக்குத் திரும்பவும்", "si": "පුවරුවට ආපසු"},

    // Categories
    "cat_vegetables": {"en": "Vegetables", "ta": "காய்கறிகள்", "si": "එළවළු"},
    "cat_fruits": {"en": "Fruits", "ta": "பழங்கள்", "si": "පළතුරු"},
    "cat_grains": {"en": "Grains", "ta": "தானியங்கள்", "si": "ධාන්‍ය"},
    "cat_other": {"en": "Other Produce", "ta": "மற்ற பொருட்கள்", "si": "අනෙකුත් නිෂ්පාදන"},

    // My Orders (Customer)
    "my_orders_title": {"en": "My Orders", "ta": "என் ஆர்டர்கள்", "si": "මගේ ඇණවුම්"},
    "tap_show_qr": {"en": "Tap to show QR", "ta": "QR காட்ட தட்டவும்", "si": "QR පෙන්වීමට තට්ටු කරන්න"},

    // Notifications
    "notifications_title": {"en": "Notifications", "ta": "அறிவிப்புகள்", "si": "දැනුම්දීම්"},
    "no_notifications_yet": {"en": "No notifications yet", "ta": "இன்னும் அறிவிப்புகள் இல்லை", "si": "තවම දැනුම්දීම් නැත"},

    // QR Scanner
    "qr_scanner_title": {"en": "QR Scanner", "ta": "QR ஸ்கேனர்", "si": "QR ස්කෑනරය"},
    "scan_customer_qr": {"en": "Scan Customer QR", "ta": "வாடிக்கையாளர் QR-ஐ ஸ்கேன் செய்யவும்", "si": "පාරිභෝගික QR ස්කෑන් කරන්න"},
    "after_scan_confirm": {"en": "After scanning, confirm product collection", "ta": "ஸ்கேன் செய்த பிறகு, பொருள் பெறுதலை உறுதி செய்யவும்", "si": "ස්කෑන් කිරීමෙන් පසු, එකතු කිරීම තහවුරු කරන්න"},
    "no_orders_ready": {"en": "No orders ready for collection", "ta": "சேகரிப்புக்கு ஆர்டர்கள் இல்லை", "si": "එකතු කිරීමට ඇණවුම් නොමැත"},
    "select_order_simulate": {"en": "Select Order (simulate scan)", "ta": "ஆர்டரைத் தேர்வு செய்யவும் (ஸ்கேன் simulate)", "si": "ඇණවුම තෝරන්න (ස්කෑන් සිමියුලේට්)"},
    "confirming": {"en": "Confirming...", "ta": "உறுதி செய்யப்படுகிறது...", "si": "තහවුරු කරමින්..."},
    "confirm_collection": {"en": "Confirm Collection", "ta": "பெறுதலை உறுதி செய்யவும்", "si": "එකතු කිරීම තහවුරු කරන්න"},
    "order_marked_collected": {"en": "Order marked as Collected!", "ta": "ஆர்டர் பெறப்பட்டதாக குறிக்கப்பட்டது!", "si": "ඇණවුම එකතු කළ ලෙස සලකුණු කරන ලදී!"},
    "scan_qr_camera_btn": {"en": "Scan QR Code", "ta": "QR குறியீட்டை ஸ்கேன் செய்யவும்", "si": "QR කේතය ස්කෑන් කරන්න"},
    "point_camera_qr": {"en": "Point camera at QR code", "ta": "கேமராவை QR குறியீட்டில் நோக்கவும்", "si": "කැමරාව QR කේතය දෙසට යොමු කරන්න"},
    "invalid_qr": {"en": "Invalid or unrecognized QR code", "ta": "தவறான QR குறியீடு", "si": "වලංගු නොවන QR කේතයකි"},
    "order_found": {"en": "Order found!", "ta": "ஆர்டர் கிடைத்தது!", "si": "ඇණවුම හමු විය!"},
    "or_manual_select": {"en": "or select manually below", "ta": "அல்லது கீழே கைமுறையாகத் தேர்வு செய்யவும்", "si": "හෝ පහත මෙනුවෙන් තෝරන්න"},

    // Reservation Detail
    "reservation_details_title": {"en": "Reservation Details", "ta": "முன்பதிவு விவரங்கள்", "si": "වෙන්කිරීමේ විස්තර"},
    "quantity_label": {"en": "Quantity", "ta": "அளவு", "si": "ප්‍රමාණය"},
    "updating": {"en": "Updating...", "ta": "புதுப்பிக்கப்படுகிறது...", "si": "යාවත්කාලීන කරමින්..."},
    "mark_as_ready": {"en": "MARK AS READY", "ta": "தயார் என குறிக்கவும்", "si": "සූදානම් ලෙස සලකුණු කරන්න"},
    "order_ready_msg": {"en": "Order marked as Ready for collection!", "ta": "ஆர்டர் சேகரிப்புக்கு தயார் என குறிக்கப்பட்டது!", "si": "ඇණවුම එකතු කිරීමට සූදානම් ලෙස සලකුණු කරන ලදී!"},
    "order_collected_msg": {"en": "This order has been collected", "ta": "இந்த ஆர்டர் பெறப்பட்டது", "si": "මෙම ඇණවුම එකතු කර ඇත"},
    "waiting_customer_collect": {"en": "Waiting for customer to collect", "ta": "வாடிக்கையாளர் பெறுவதற்காக காத்திருக்கிறது", "si": "පාරිභෝගිකයා එකතු කිරීමට රැඳී සිටිමින්"},

    // Demand Prediction
    "demand_prediction_title": {"en": "Demand Prediction", "ta": "தேவை முன்னறிவிப்பு", "si": "ඉල්ලුම් අනාවැකිය"},
    "ai_forecast_desc": {"en": "AI-powered demand forecast based on market conditions", "ta": "சந்தை நிலைமைகளின் அடிப்படையில் AI தேவை முன்னறிவிப்பு", "si": "වෙළඳපොල තත්ත්වය මත පදනම් වූ AI ඉල්ලුම් අනාවැකිය"},
    "region_label": {"en": "Region", "ta": "பிராந்தியம்", "si": "කලාපය"},
    "inventory_level_label": {"en": "Inventory Level", "ta": "இருப்பு அளவு", "si": "තොග මට්ටම"},
    "units_sold_label": {"en": "Units Sold", "ta": "விற்பனையான அலகுகள்", "si": "විකුණන ලද ඒකක"},
    "units_ordered_label": {"en": "Units Ordered", "ta": "ஆர்டர் செய்யப்பட்ட அலகுகள்", "si": "ඇණවුම් කළ ඒකක"},
    "discount_pct_label": {"en": "Discount %", "ta": "தள்ளுபடி %", "si": "වට්ටම %"},
    "competitor_pricing_label": {"en": "Competitor Pricing (Rs)", "ta": "போட்டியாளர் விலை (ரூ)", "si": "තරඟකාරී මිල (රු)"},
    "weather_label": {"en": "Weather", "ta": "வானிலை", "si": "කාලගුණය"},
    "season_label": {"en": "Season", "ta": "பருவம்", "si": "කන්නය"},
    "promotion_active_label": {"en": "Promotion Active", "ta": "விளம்பரம் செயலில்", "si": "ප්‍රවර්ධනය සක්‍රියයි"},
    "epidemic_label": {"en": "Epidemic/Outbreak Situation", "ta": "தொற்று/வெடிப்பு நிலைமை", "si": "වසංගත තත්ත්වය"},
    "predicting": {"en": "Predicting...", "ta": "முன்னறிவிக்கப்படுகிறது...", "si": "අනාවැකි කියමින්..."},
    "predict_demand_btn": {"en": "Predict Demand", "ta": "தேவையை முன்னறிவிக்கவும்", "si": "ඉල්ලුම අනාවැකි කියන්න"},
    "predicted_demand_label": {"en": "Predicted Demand", "ta": "முன்னறிவிக்கப்பட்ட தேவை", "si": "අනාවැකි කළ ඉල්ලුම"},
    "units_suffix": {"en": "units", "ta": "அலகுகள்", "si": "ඒකක"},
    "weather_sunny": {"en": "Sunny", "ta": "வெயில்", "si": "අව්ව"},
    "weather_rainy": {"en": "Rainy", "ta": "மழை", "si": "වැසි"},
    "weather_cloudy": {"en": "Cloudy", "ta": "மேகமூட்டம்", "si": "වළාකුළු"},
    "weather_snowy": {"en": "Snowy", "ta": "பனி", "si": "හිම"},
    "season_summer": {"en": "Summer", "ta": "கோடை", "si": "ග්‍රීෂ්ම"},
    "season_winter": {"en": "Winter", "ta": "குளிர்காலம்", "si": "ශීත"},
    "season_spring": {"en": "Spring", "ta": "வசந்தம்", "si": "වසන්ත"},
    "season_autumn": {"en": "Autumn", "ta": "இலையுதிர்", "si": "සරත්"},
    "region_north": {"en": "North", "ta": "வடக்கு", "si": "උතුර"},
    "region_south": {"en": "South", "ta": "தெற்கு", "si": "දකුණ"},
    "region_east": {"en": "East", "ta": "கிழக்கு", "si": "නැගෙනහිර"},
    "region_west": {"en": "West", "ta": "மேற்கு", "si": "බස්නාහිර"},

    // Sales Analytics
    "sales_analytics_title": {"en": "Sales Analytics", "ta": "விற்பனை பகுப்பாய்வு", "si": "විකුණුම් විශ්ලේෂණ"},
    "total_earnings_alltime": {"en": "Total Earnings (All Time)", "ta": "மொத்த வருமானம் (எல்லா காலமும்)", "si": "සම්පූර්ණ ආදායම (සියලු කාලය)"},
    "this_week_label": {"en": "This Week", "ta": "இந்த வாரம்", "si": "මෙම සතිය"},
    "top_products_alltime": {"en": "Top Products (All Time)", "ta": "முதன்மை பொருட்கள் (எல்லா காலமும்)", "si": "ඉහළම නිෂ්පාදන (සියලු කාලය)"},
    "no_completed_sales": {"en": "No completed sales yet", "ta": "இன்னும் விற்பனை முடிவடையவில்லை", "si": "තවම විකුණුම් සම්පූර්ණ වී නැත"},
    "this_month_by_week": {"en": "This Month (by week)", "ta": "இந்த மாதம் (வாரம் வாரம்)", "si": "මෙම මාසය (සතිය අනුව)"},
    "no_sales_this_month": {"en": "No sales this month yet", "ta": "இந்த மாதம் விற்பனை இல்லை", "si": "මෙම මාසයේ විකුණුම් නැත"},

    // Spending Analytics
    "total_spent_alltime": {"en": "Total Spent (All Time)", "ta": "மொத்த செலவு (எல்லா காலமும்)", "si": "සම්පූර්ණ වැය (සියලු කාලය)"},
    "most_purchased_alltime": {"en": "Most Purchased (All Time)", "ta": "அதிகம் வாங்கியவை (எல்லா காலமும்)", "si": "වැඩිපුරම මිලදී ගත් (සියලු කාලය)"},
    "no_completed_purchases": {"en": "No completed purchases yet", "ta": "இன்னும் வாங்குதல் முடிவடையவில்லை", "si": "තවම මිලදී ගැනීම් සම්පූර්ණ වී නැත"},
    "no_purchases_this_month": {"en": "No purchases this month yet", "ta": "இந்த மாதம் வாங்குதல் இல்லை", "si": "මෙම මාසයේ මිලදී ගැනීම් නැත"},

    // Admin
    "admin_dashboard_title": {"en": "Admin Dashboard", "ta": "நிர்வாக டாஷ்போர்டு", "si": "පරිපාලක පුවරුව"},
    "platform_administration": {"en": "Platform Administration", "ta": "தளம் நிர்வாகம்", "si": "වේදිකා පරිපාලනය"},
    "manage_users": {"en": "Manage Users", "ta": "பயனர்களை நிர்வகிக்கவும்", "si": "පරිශීලකයින් කළමනාකරණය"},
    "manage_products": {"en": "Manage Products", "ta": "பொருட்களை நிர்வகிக்கவும்", "si": "නිෂ්පාදන කළමනාකරණය"},
    "no_users_found": {"en": "No users found", "ta": "பயனர்கள் இல்லை", "si": "පරිශීලකයින් හමු නොවුණි"},
    "remove_user_title": {"en": "Remove User", "ta": "பயனரை நீக்கு", "si": "පරිශීලකයා ඉවත් කරන්න"},
    "no_products_found_admin": {"en": "No products found", "ta": "பொருட்கள் இல்லை", "si": "නිෂ්පාදන හමු නොවුණි"},
    "remove_listing_title": {"en": "Remove Listing", "ta": "பட்டியலை நீக்கு", "si": "ලැයිස්තුව ඉවත් කරන්න"},
    "farmer_prefix": {"en": "Farmer", "ta": "விவசாயி", "si": "ගොවියා"},
    "status_available": {"en": "Available", "ta": "கிடைக்கிறது", "si": "තිබේ"},
    "status_soldout": {"en": "Sold Out", "ta": "விற்று தீர்ந்தது", "si": "විකුණා අවසන්"},
    "remove_confirm_msg": {"en": "Remove {name} permanently?", "ta": "{name}-ஐ நிரந்தரமாக நீக்கவா?", "si": "{name} ස්ථිරවම ඉවත් කරන්නද?"},
    "edit_product_title": {"en": "Edit Product", "ta": "பொருளைத் திருத்தவும்", "si": "නිෂ්පාදනය සංස්කරණය කරන්න"},
    "editing_prefix": {"en": "Editing", "ta": "திருத்துகிறது", "si": "සංස්කරණය කරමින්"},
    "update_product_btn": {"en": "UPDATE PRODUCT", "ta": "பொருளைப் புதுப்பிக்கவும்", "si": "නිෂ්පාදනය යාවත්කාලීන කරන්න"},

    // Cart
    "cart_title": {"en": "My Cart", "ta": "என் கூடை", "si": "මගේ කරත්තය"},
    "cart_empty": {"en": "Your cart is empty", "ta": "உங்கள் கூடை காலியாக உள்ளது", "si": "ඔබේ කරත්තය හිස්ය"},
    "cart_total": {"en": "Total", "ta": "மொத்தம்", "si": "එකතුව"},
    "proceed_checkout": {"en": "Proceed to Checkout", "ta": "செக்அவுட்டிற்குச் செல்லவும்", "si": "ගෙවීමට යන්න"},
    "added_to_cart": {"en": "Added to cart!", "ta": "கூடையில் சேர்க்கப்பட்டது!", "si": "කරත්තයට එකතු කරන ලදී!"},
    "part_of_multi_order": {"en": "Part of a {count}-item order", "ta": "{count} பொருட்கள் கொண்ட ஆர்டரின் ஒரு பகுதி", "si": "අයිතම {count}ක ඇණවුමක කොටසක්"},
  };

  static final Map<String, Map<String, String>> _collectionPoints = {
    "Jaffna Collection Center": {"ta": "யாழ்ப்பாணம் சேகரிப்பு மையம்", "si": "යාපනය එකතු කිරීමේ මධ්‍යස්ථානය"},
    "Vavuniya Collection Center": {"ta": "வவுனியா சேகரிப்பு மையம்", "si": "වවුනියාව එකතු කිරීමේ මධ්‍යස්ථානය"},
    "Kilinochi Collection Center": {"ta": "கிளிநொச்சி சேகரிப்பு மையம்", "si": "කිලිනොච්චිය එකතු කිරීමේ මධ්‍යස්ථානය"},
    "Mannar Collection Center": {"ta": "மன்னார் சேகரிப்பு மையம்", "si": "මන්නාරම එකතු කිරීමේ මධ්‍යස්ථානය"},
    "Trincomalee Collection Center": {"ta": "திருகோணமலை சேகரிப்பு மையம்", "si": "ත්‍රිකුණාමලය එකතු කිරීමේ මධ්‍යස්ථානය"},
  };

  static String tCollectionPoint(String englishName) {
    final entry = _collectionPoints[englishName];
    if (entry == null) return englishName;
    return entry[currentLang] ?? englishName;
  }

  static final Map<String, Map<String, String>> _notifTemplates = {
    "new_order": {
      "en": "New order received for {product} ({qty} Kg)",
      "ta": "{product} ({qty} கிலோ) - புதிய ஆர்டர் வந்துள்ளது",
      "si": "නව ඇණවුමක් ලැබී ඇත {product} ({qty} kg)",
    },
    "ready": {
      "en": "Your order for {product} is ready for collection!",
      "ta": "உங்கள் {product} ஆர்டர் சேகரிப்புக்கு தயாராக உள்ளது!",
      "si": "ඔබේ {product} ඇණවුම එකතු කිරීමට සූදානම්!",
    },
    "collected": {
      "en": "{product} has been collected by the customer.",
      "ta": "{product} வாடிக்கையாளரால் பெறப்பட்டது.",
      "si": "{product} පාරිභෝගිකයා විසින් එකතු කරන ලදී.",
    },
  };

  static String translateNotification(
    String rawMessage,
    String currentLangCode,
    String Function(String) localizeProductName,
  ) {
    final newOrderMatch = RegExp(r"^New order received for (.+) \(([\d.]+) Kg\)$").firstMatch(rawMessage);
    if (newOrderMatch != null) {
      final product = localizeProductName(newOrderMatch.group(1)!.trim());
      final qty = newOrderMatch.group(2)!;
      final template = _notifTemplates["new_order"]?[currentLangCode] ?? rawMessage;
      return template.replaceAll("{product}", product).replaceAll("{qty}", qty);
    }

    final readyMatch = RegExp(r"^Your order for (.+) is ready for collection!$").firstMatch(rawMessage);
    if (readyMatch != null) {
      final product = localizeProductName(readyMatch.group(1)!.trim());
      final template = _notifTemplates["ready"]?[currentLangCode] ?? rawMessage;
      return template.replaceAll("{product}", product);
    }

    final collectedMatch = RegExp(r"^(.+) has been collected by the customer\.$").firstMatch(rawMessage);
    if (collectedMatch != null) {
      final product = localizeProductName(collectedMatch.group(1)!.trim());
      final template = _notifTemplates["collected"]?[currentLangCode] ?? rawMessage;
      return template.replaceAll("{product}", product);
    }

    return rawMessage;
  }

  static String t(String key) {
    return _translations[key]?[currentLang] ?? key;
  }
}