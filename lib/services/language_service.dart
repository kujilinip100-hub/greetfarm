class LanguageService {
  static String currentLang = "en"; // en / ta / si

  static final Map<String, Map<String, String>> _translations = {
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
  };

  static String t(String key) {
    return _translations[key]?[currentLang] ?? key;
  }
}