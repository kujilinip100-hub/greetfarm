class ProductImageData {
  final String file;
  final String asset;
  final String label;
  final String category;
  final String labelTa;
  final String labelSi;

  const ProductImageData({
    required this.file,
    required this.asset,
    required this.label,
    this.category = "Vegetables",
    this.labelTa = "",
    this.labelSi = "",
  });

  // Current language-ku thakka label kudukkum
  String localizedLabel(String lang) {
    if (lang == "ta" && labelTa.isNotEmpty) return labelTa;
    if (lang == "si" && labelSi.isNotEmpty) return labelSi;
    return label;
  }
}

// PUTHU IMAGE add pண்ணும்pothு, IDHU ONE FILE mattum edit pண்ணினா podhum
const List<ProductImageData> allProductImages = [
  // ---------------- Vegetables ----------------
  ProductImageData(file: "Tomato.png", asset: "assets/images/Tomato.png", label: "Tomato", category: "Vegetables", labelTa: "தக்காளி", labelSi: "තක්කාලි"),
  ProductImageData(file: "Tomato1.jpg", asset: "assets/images/Tomato1.jpg", label: "Tomato", category: "Vegetables", labelTa: "தக்காளி", labelSi: "තක්කාලි"),
  ProductImageData(file: "carrot.jpg", asset: "assets/images/carrot.jpg", label: "Carrot", category: "Vegetables", labelTa: "கேரட்", labelSi: "කැරට්"),
  ProductImageData(file: "Cabbage.jpg", asset: "assets/images/Cabbage.jpg", label: "Cabbage", category: "Vegetables", labelTa: "முட்டைக்கோஸ்", labelSi: "ගෝවා"),
  ProductImageData(file: "Capsicum.jpg", asset: "assets/images/Capsicum.jpg", label: "Capsicum", category: "Vegetables", labelTa: "குடமிளகாய்", labelSi: "මාළු මිරිස්"),
  ProductImageData(file: "Garlic.jpg", asset: "assets/images/Garlic.jpg", label: "Garlic", category: "Vegetables", labelTa: "பூண்டு", labelSi: "සුදු ලූනු"),
  ProductImageData(file: "Lettuce.jpg", asset: "assets/images/Lettuce.jpg", label: "Lettuce", category: "Vegetables", labelTa: "லெட்டூஸ்", labelSi: "සලාද කොළ"),
  ProductImageData(file: "Pumkin1.jpg", asset: "assets/images/Pumkin1.jpg", label: "Pumpkin", category: "Vegetables", labelTa: "பூசணி", labelSi: "වට්ටක්කා"),
  ProductImageData(file: "Spinach.jpg", asset: "assets/images/Spinach.jpg", label: "Spinach", category: "Vegetables", labelTa: "பசலைக்கீரை", labelSi: "නිවිති"),
  ProductImageData(file: "baby spinach.jpg", asset: "assets/images/baby spinach.jpg", label: "Baby Spinach", category: "Vegetables", labelTa: "சிறிய பசலைக்கீரை", labelSi: "බේබි නිවිති"),
  ProductImageData(file: "beans.jpg", asset: "assets/images/beans.jpg", label: "Beans", category: "Vegetables", labelTa: "பீன்ஸ்", labelSi: "බෝංචි"),
  ProductImageData(file: "Beetroot.jpg", asset: "assets/images/Beetroot.jpg", label: "Beetroot", category: "Vegetables", labelTa: "பீட்ரூட்", labelSi: "බීට් රූට්"),
  ProductImageData(file: "bell pepper.jpg", asset: "assets/images/bell pepper.jpg", label: "Bell Pepper", category: "Vegetables", labelTa: "குடமிளகாய்", labelSi: "බෙල් පෙපර්"),
  ProductImageData(file: "green chili.jpg", asset: "assets/images/green chili.jpg", label: "Green Chili", category: "Vegetables", labelTa: "பச்சை மிளகாய்", labelSi: "කොළ මිරිස්"),
  ProductImageData(file: "shallots.jpg", asset: "assets/images/shallots.jpg", label: "Shallots", category: "Vegetables", labelTa: "சிவப்பு வெங்காயம்", labelSi: "රතු ලූනු"),
  ProductImageData(file: "Onion.jpg", asset: "assets/images/Onion.jpg", label: "Onion", category: "Vegetables", labelTa: "வெங்காயம்", labelSi: "ලූනු"),
  ProductImageData(file: "Pototo.jpg", asset: "assets/images/Pototo.jpg", label: "Potato", category: "Vegetables", labelTa: "உருளைக்கிழங்கு", labelSi: "අල"),
  ProductImageData(file: "bitter gourd.jpg", asset: "assets/images/bitter gourd.jpg", label: "Bitter Gourd", category: "Vegetables", labelTa: "பாகற்காய்", labelSi: "කරවිල"),
  ProductImageData(file: "bok choy.jpg", asset: "assets/images/bok choy.jpg", label: "Bok Choy", category: "Vegetables", labelTa: "பாக் சாய்", labelSi: "බොක් චෝයි"),
  ProductImageData(file: "bottle gourd.jpg", asset: "assets/images/bottle gourd.jpg", label: "Bottle Gourd", category: "Vegetables", labelTa: "சுரைக்காய்", labelSi: "දිය ලබු"),
  ProductImageData(file: "Brinjal.jpg", asset: "assets/images/Brinjal.jpg", label: "Brinjal", category: "Vegetables", labelTa: "கத்தரிக்காய்", labelSi: "වම්බටු"),
  ProductImageData(file: "broccoli.jpg", asset: "assets/images/broccoli.jpg", label: "Broccoli", category: "Vegetables", labelTa: "ப்ரோக்கோலி", labelSi: "බ්‍රොකොලි"),
  ProductImageData(file: "Cauliflower.jpg", asset: "assets/images/Cauliflower.jpg", label: "Cauliflower", category: "Vegetables", labelTa: "காலிஃபிளவர்", labelSi: "මාළු ගෝවා"),
  ProductImageData(file: "celery.jpg", asset: "assets/images/celery.jpg", label: "Celery", category: "Vegetables", labelTa: "செலரி", labelSi: "සෙලරි"),
  ProductImageData(file: "Corn.jpg", asset: "assets/images/Corn.jpg", label: "Corn (Sweet)", category: "Vegetables", labelTa: "மக்காச்சோளம்", labelSi: "බඩ ඉරිඟු"),
  ProductImageData(file: "cucumber.jpg", asset: "assets/images/cucumber.jpg", label: "Cucumber", category: "Vegetables", labelTa: "வெள்ளரிக்காய்", labelSi: "පිපිඤ්ඤා"),
  ProductImageData(file: "curry leaves.jpg", asset: "assets/images/curry leaves.jpg", label: "Curry Leaves", category: "Vegetables", labelTa: "கருவேப்பிலை", labelSi: "කරපිංචා"),
  ProductImageData(file: "fennel.jpg", asset: "assets/images/fennel.jpg", label: "Fennel", category: "Vegetables", labelTa: "பெருஞ்சீரகம்", labelSi: "මාදුරු"),
  ProductImageData(file: "fenugreek leaves.jpg", asset: "assets/images/fenugreek leaves.jpg", label: "Fenugreek", category: "Vegetables", labelTa: "வெந்தயக்கீரை", labelSi: "උළුහාල්"),
  ProductImageData(file: "flat beans.jpg", asset: "assets/images/flat beans.jpg", label: "Flat Beans", category: "Vegetables", labelTa: "அவரைக்காய்", labelSi: "අවර බෝංචි"),
  ProductImageData(file: "ginger1.jpg", asset: "assets/images/ginger1.jpg", label: "Ginger", category: "Vegetables", labelTa: "இஞ்சி", labelSi: "ඉඟුරු"),
  ProductImageData(file: "horseradish.jpg", asset: "assets/images/horseradish.jpg", label: "Horseradish", category: "Vegetables", labelTa: "குதிரை முள்ளங்கி", labelSi: "හෝස් රැඩිෂ්"),
  ProductImageData(file: "kale.jpg", asset: "assets/images/kale.jpg", label: "Kale", category: "Vegetables", labelTa: "கேல் கீரை", labelSi: "කේල්"),
  ProductImageData(file: "keerai.jpg", asset: "assets/images/keerai.jpg", label: "Keerai", category: "Vegetables", labelTa: "கீரை", labelSi: "පලා"),
  ProductImageData(file: "lady's finger.jpg", asset: "assets/images/lady's finger.jpg", label: "Lady's Finger", category: "Vegetables", labelTa: "வெண்டைக்காய்", labelSi: "බණ්ඩක්කා"),
  ProductImageData(file: "leek.png", asset: "assets/images/leek.png", label: "Leek", category: "Vegetables", labelTa: "லீக்", labelSi: "ලීක්"),
  ProductImageData(file: "mint.jpg", asset: "assets/images/mint.jpg", label: "Mint", category: "Vegetables", labelTa: "புதினா", labelSi: "මින්ට්"),
  ProductImageData(file: "moringa.jpg", asset: "assets/images/moringa.jpg", label: "Moringa", category: "Vegetables", labelTa: "முருங்கை", labelSi: "මුරුංගා"),
  ProductImageData(file: "mushroom.jpg", asset: "assets/images/mushroom.jpg", label: "Mushroom", category: "Vegetables", labelTa: "காளான்", labelSi: "බිම්මල්"),
  ProductImageData(file: "radish.jpg", asset: "assets/images/radish.jpg", label: "Radish", category: "Vegetables", labelTa: "முள்ளங்கி", labelSi: "රාබු"),
  ProductImageData(file: "red cabbage.jpg", asset: "assets/images/red cabbage.jpg", label: "Red Cabbage", category: "Vegetables", labelTa: "சிவப்பு முட்டைக்கோஸ்", labelSi: "රතු ගෝවා"),
  ProductImageData(file: "red chillies.jpg", asset: "assets/images/red chillies.jpg", label: "Red Chillies", category: "Vegetables", labelTa: "சிவப்பு மிளகாய்", labelSi: "රතු මිරිස්"),
  ProductImageData(file: "saladhu.jpg", asset: "assets/images/saladhu.jpg", label: "Salad Greens", category: "Vegetables", labelTa: "சாலட் கீரை", labelSi: "සලාද කොළ"),
  ProductImageData(file: "sweet potato.jpg", asset: "assets/images/sweet potato.jpg", label: "Sweet Potato", category: "Vegetables", labelTa: "வள்ளிக்கிழங்கு", labelSi: "බතල"),
  ProductImageData(file: "taro root.jpg", asset: "assets/images/taro root.jpg", label: "Taro Root", category: "Vegetables", labelTa: "சேப்பங்கிழங்கு", labelSi: "කිරි අල"),
  ProductImageData(file: "turnip.jpg", asset: "assets/images/turnip.jpg", label: "Turnip", category: "Vegetables", labelTa: "டர்னிப்", labelSi: "ටර්නිප්"),
  ProductImageData(file: "raw banana.jpg", asset: "assets/images/raw banana.jpg", label: "Raw Banana", category: "Vegetables", labelTa: "வாழைக்காய்", labelSi: "කෙසෙල් (අමු)"),

  // ---------------- Fruits ----------------
  ProductImageData(file: "avocado.jpg", asset: "assets/images/avocado.jpg", label: "Avocado", category: "Fruits", labelTa: "அவகேடோ", labelSi: "අලිගැටපේර"),
  ProductImageData(file: "banana.jpg", asset: "assets/images/banana.jpg", label: "Banana", category: "Fruits", labelTa: "வாழைப்பழம்", labelSi: "කෙසෙල්"),
  ProductImageData(file: "grapes.jpg", asset: "assets/images/grapes.jpg", label: "Grapes", category: "Fruits", labelTa: "திராட்சை", labelSi: "මිදි"),
  ProductImageData(file: "guava.jpg", asset: "assets/images/guava.jpg", label: "Guava", category: "Fruits", labelTa: "கொய்யா", labelSi: "පේර"),
  ProductImageData(file: "jackfruit.jpg", asset: "assets/images/jackfruit.jpg", label: "Jackfruit", category: "Fruits", labelTa: "பலாப்பழம்", labelSi: "කොස්"),
  ProductImageData(file: "lime.jpg", asset: "assets/images/lime.jpg", label: "Lime", category: "Fruits", labelTa: "எலுமிச்சை", labelSi: "දෙහි"),
  ProductImageData(file: "mango.jpg", asset: "assets/images/mango.jpg", label: "Mango", category: "Fruits", labelTa: "மாம்பழம்", labelSi: "අඹ"),
  ProductImageData(file: "mangosteen.jpg", asset: "assets/images/mangosteen.jpg", label: "Mangosteen", category: "Fruits", labelTa: "மாங்கஸ்தீன்", labelSi: "මැංගුස්ටින්"),
  ProductImageData(file: "orange.jpg", asset: "assets/images/orange.jpg", label: "Orange", category: "Fruits", labelTa: "ஆரஞ்சு", labelSi: "දොඩම්"),
  ProductImageData(file: "papaya.jpg", asset: "assets/images/papaya.jpg", label: "Papaya", category: "Fruits", labelTa: "பப்பாளி", labelSi: "පැපොල්"),
  ProductImageData(file: "pineapple.jpg", asset: "assets/images/pineapple.jpg", label: "Pineapple", category: "Fruits", labelTa: "அன்னாசி", labelSi: "අන්නාසි"),
  ProductImageData(file: "pomegranate.jpg", asset: "assets/images/pomegranate.jpg", label: "Pomegranate", category: "Fruits", labelTa: "மாதுளை", labelSi: "දෙළුම්"),
  ProductImageData(file: "watermelon.jpg", asset: "assets/images/watermelon.jpg", label: "Watermelon", category: "Fruits", labelTa: "தர்பூசணி", labelSi: "පේර වැල්ලං"),

  // ---------------- Grains ----------------
  ProductImageData(file: "rice1.jpg", asset: "assets/images/rice1.jpg", label: "Rice", category: "Grains", labelTa: "அரிசி", labelSi: "සහල්"),
  ProductImageData(file: "red rice.jpg", asset: "assets/images/red rice.jpg", label: "Red Rice", category: "Grains", labelTa: "சிவப்பு அரிசி", labelSi: "රතු සහල්"),
  ProductImageData(file: "maize.jpg", asset: "assets/images/maize.jpg", label: "Maize", category: "Grains", labelTa: "மக்காச்சோளம்", labelSi: "ඉරිඟු"),
  ProductImageData(file: "green gram.jpg", asset: "assets/images/green gram.jpg", label: "Green Gram", category: "Grains", labelTa: "பாசிப்பயறு", labelSi: "මුං ඇට"),
  ProductImageData(file: "black gram.jpg", asset: "assets/images/black gram.jpg", label: "Black Gram", category: "Grains", labelTa: "உளுந்து", labelSi: "උඳු"),
  ProductImageData(file: "red lentils.jpg", asset: "assets/images/red lentils.jpg", label: "Red Lentils", category: "Grains", labelTa: "சிவப்பு பருப்பு", labelSi: "රතු පරිප්පු"),
  ProductImageData(file: "sesame.jpg", asset: "assets/images/sesame.jpg", label: "Sesame", category: "Grains", labelTa: "எள்", labelSi: "තල"),
  ProductImageData(file: "finger millet.jpg", asset: "assets/images/finger millet.jpg", label: "Finger Millet", category: "Grains", labelTa: "கேழ்வரகு", labelSi: "කුරක්කන්"),

  ProductImageData(file: "no_image.jpg", asset: "", label: "Other", category: "Other Produce"),
];

// Central helper — endha screen-layum idhe function-a use pannunga
// image filename vachu, current language-ku thakka product name-a kudukkum
String getLocalizedProductName(String? imageFile, String fallback, String currentLang) {
  final match = allProductImages.where(
    (img) => img.file.toLowerCase() == imageFile?.toLowerCase().trim(),
  ).toList();
  if (match.isEmpty) return fallback;
  return match.first.localizedLabel(currentLang);
}

// Image filename theriyaama, English label (peru) vachu mattum lookup pannum
// (Notifications message-la image filename varaadhu, product name text mattum varum)
String getLocalizedProductNameByLabel(String englishLabel, String currentLang) {
  final match = allProductImages.where(
    (img) => img.label.toLowerCase() == englishLabel.toLowerCase().trim(),
  ).toList();
  if (match.isEmpty) return englishLabel;
  return match.first.localizedLabel(currentLang);
}