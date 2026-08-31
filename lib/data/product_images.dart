class ProductImageData {
  final String file;
  final String asset;
  final String label;
  final String category;

  const ProductImageData({
    required this.file,
    required this.asset,
    required this.label,
    required this.category,
  });
}

// When adding a NEW IMAGE, editing this ONE FILE alone is enough
// The categories: "Vegetables", "Fruits", "Grains", "Other Produce"
// these four must match the category list on the Demand Prediction screen
const List<ProductImageData> allProductImages = [
  ProductImageData(file: "Tomato.png", asset: "assets/images/Tomato.png", label: "Tomato", category: "Vegetables"),
  ProductImageData(file: "Tomato1.jpg", asset: "assets/images/Tomato1.jpg", label: "Tomato", category: "Vegetables"),
  ProductImageData(file: "carrot.jpg", asset: "assets/images/carrot.jpg", label: "Carrot", category: "Vegetables"),
  ProductImageData(file: "Cabbage.jpg", asset: "assets/images/Cabbage.jpg", label: "Cabbage", category: "Vegetables"),
  ProductImageData(file: "Capsicum.jpg", asset: "assets/images/Capsicum.jpg", label: "Capsicum", category: "Vegetables"),
  ProductImageData(file: "Garlic.jpg", asset: "assets/images/Garlic.jpg", label: "Garlic", category: "Vegetables"),
  ProductImageData(file: "Lettuce.jpg", asset: "assets/images/Lettuce.jpg", label: "Lettuce", category: "Vegetables"),
  ProductImageData(file: "Pumkin1.jpg", asset: "assets/images/Pumkin1.jpg", label: "Pumpkin", category: "Vegetables"),
  ProductImageData(file: "Spinach.jpg", asset: "assets/images/Spinach.jpg", label: "Spinach", category: "Vegetables"),
  ProductImageData(file: "beans.jpg", asset: "assets/images/beans.jpg", label: "Beans", category: "Vegetables"),
  ProductImageData(file: "Beetroot.jpg", asset: "assets/images/Beetroot.jpg", label: "Beetroot", category: "Vegetables"),
  ProductImageData(file: "bell pepper.jpg", asset: "assets/images/bell pepper.jpg", label: "Bell Pepper", category: "Vegetables"),
  ProductImageData(file: "green chili.jpg", asset: "assets/images/green chili.jpg", label: "Green Chili", category: "Vegetables"),
  ProductImageData(file: "shallots.jpg", asset: "assets/images/shallots.jpg", label: "Shallots", category: "Vegetables"),
  ProductImageData(file: "Onion.jpg", asset: "assets/images/Onion.jpg", label: "Onion", category: "Vegetables"),
  ProductImageData(file: "Pototo.jpg", asset: "assets/images/Pototo.jpg", label: "Potato", category: "Vegetables"),
  ProductImageData(file: "bitter gourd.jpg", asset: "assets/images/bitter gourd.jpg", label: "Bitter Gourd", category: "Vegetables"),
  ProductImageData(file: "bok choy.jpg", asset: "assets/images/bok choy.jpg", label: "Bok Choy", category: "Vegetables"),
  ProductImageData(file: "bottle gourd.jpg", asset: "assets/images/bottle gourd.jpg", label: "Bottle Gourd", category: "Vegetables"),
  ProductImageData(file: "Brinjal.jpg", asset: "assets/images/Brinjal.jpg", label: "Brinjal", category: "Vegetables"),
  ProductImageData(file: "broccoli.jpg", asset: "assets/images/broccoli.jpg", label: "Broccoli", category: "Vegetables"),
  ProductImageData(file: "Cauliflower.jpg", asset: "assets/images/Cauliflower.jpg", label: "Cauliflower", category: "Vegetables"),
  ProductImageData(file: "celery.jpg", asset: "assets/images/celery.jpg", label: "Celery", category: "Vegetables"),
  ProductImageData(file: "Corn.jpg", asset: "assets/images/Corn.jpg", label: "Corn", category: "Vegetables"),
  ProductImageData(file: "cucumber.jpg", asset: "assets/images/cucumber.jpg", label: "Cucumber", category: "Vegetables"),
  ProductImageData(file: "curry leaves.jpg", asset: "assets/images/curry leaves.jpg", label: "Curry Leaves", category: "Vegetables"),
  ProductImageData(file: "fenugreek leaves.jpg", asset: "assets/images/fenugreek leaves.jpg", label: "Fenugreek", category: "Vegetables"),
  ProductImageData(file: "flat beans.jpg", asset: "assets/images/flat beans.jpg", label: "Flat Beans", category: "Vegetables"),
  ProductImageData(file: "ginger1.jpg", asset: "assets/images/ginger1.jpg", label: "Ginger", category: "Vegetables"),
  ProductImageData(file: "kale.jpg", asset: "assets/images/kale.jpg", label: "Kale", category: "Vegetables"),
  ProductImageData(file: "keerai.jpg", asset: "assets/images/keerai.jpg", label: "Keerai", category: "Vegetables"),
  ProductImageData(file: "lady's finger.jpg", asset: "assets/images/lady's finger.jpg", label: "Lady's Finger", category: "Vegetables"),
  ProductImageData(file: "mint.jpg", asset: "assets/images/mint.jpg", label: "Mint", category: "Vegetables"),
  ProductImageData(file: "mushroom.jpg", asset: "assets/images/mushroom.jpg", label: "Mushroom", category: "Vegetables"),
  ProductImageData(file: "radish.jpg", asset: "assets/images/radish.jpg", label: "Radish", category: "Vegetables"),
  ProductImageData(file: "red cabbage.jpg", asset: "assets/images/red cabbage.jpg", label: "Red Cabbage", category: "Vegetables"),
  ProductImageData(file: "red chillies.jpg", asset: "assets/images/red chillies.jpg", label: "Red Chillies", category: "Vegetables"),
  ProductImageData(file: "sweet potato.jpg", asset: "assets/images/sweet potato.jpg", label: "Sweet Potato", category: "Vegetables"),

  // --- Fruits (neenga images add panniya apparam, ippadi vera lines serthukonga) ---
  // ProductImageData(file: "apple.jpg", asset: "assets/images/apple.jpg", label: "Apple", category: "Fruits"),
  ProductImageData(file: "avocado.jpg", asset: "assets/images/avocado.jpg", label: "Avocado", category: "Fruits"),
  ProductImageData(file: "banana.jpg", asset: "assets/images/banana.jpg", label: "Banana", category: "Fruits"),
  ProductImageData(file: "grapes.jpg", asset: "assets/images/grapes.jpg", label: "Grapes", category: "Fruits"),
  ProductImageData(file: "guava.jpg", asset: "assets/images/guava.jpg", label: "Guava", category: "Fruits"),
  ProductImageData(file: "jackfruit.jpg", asset: "assets/images/jackfruit.jpg", label: "Jackfruit", category: "Fruits"),
  ProductImageData(file: "lime.jpg", asset: "assets/images/lime.jpg", label: "Lime", category: "Fruits"),
  ProductImageData(file: "mango.jpg", asset: "assets/images/mango.jpg", label: "Mango", category: "Fruits"),
  ProductImageData(file: "mangosteen.jpg", asset: "assets/images/mangosteen.jpg", label: "Mangosteen", category: "Fruits"),
  ProductImageData(file: "orange.jpg", asset: "assets/images/orange.jpg", label: "Orange", category: "Fruits"),
  ProductImageData(file: "papaya.jpg", asset: "assets/images/papaya.jpg", label: "Papaya", category: "Fruits"),
  ProductImageData(file: "pineapple.jpg", asset: "assets/images/pineapple.jpg", label: "Pineapple", category: "Fruits"),
  ProductImageData(file: "pomegranate.jpg", asset: "assets/images/pomegranate.jpg", label: "Pomegranate", category: "Fruits"),
  ProductImageData(file: "watermelon.jpg", asset: "assets/images/watermelon.jpg", label: "Watermelon", category: "Fruits"),
  ProductImageData(file: "banana.jpg", asset: "assets/images/banana.jpg", label: "Banana", category: "Fruits"),

  // --- Grains (idhukum apparam) ---
  // ProductImageData(file: "rice.jpg", asset: "assets/images/rice.jpg", label: "Rice", category: "Grains"),
  ProductImageData(file: "black gram.jpg", asset: "assets/images/black gram.jpg", label: "Black gram", category: "Grains"),
  ProductImageData(file: "finger millet.jpg", asset: "assets/images/finger millet.jpg", label: "Finger millet", category: "Grains"),
  ProductImageData(file: "green gram.jpg", asset: "assets/images/green gram.jpg", label: "Green gram", category: "Grains"),
  ProductImageData(file: "maize.jpg", asset: "assets/images/maize.jpg", label: "Maize", category: "Grains"),
  ProductImageData(file: "red lentils.jpg", asset: "assets/images/red lentils.jpg", label: "Red lentils", category: "Grains"),
  ProductImageData(file: "red rice.jpg", asset: "assets/images/red rice.jpg", label: "Red rice", category: "Grains"),
  ProductImageData(file: "rice1.jpg", asset: "assets/images/rice1.jpg", label: "Rice", category: "Grains"),
  ProductImageData(file: "sesame.jpg", asset: "assets/images/sesame.jpg", label: "Sesame", category: "Grains"),

  ProductImageData(file: "no_image.jpg", asset: "", label: "Other", category: "Other Produce"),
];