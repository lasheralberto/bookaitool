import 'package:flutter/material.dart';

class ColorConstants {
  static Color colortheme = const Color.fromRGBO(84, 84, 84, 1);
  static Color colorAppBar = const Color.fromRGBO(84, 84, 84, 1);
  static Color colorCard = Colors.blueGrey.shade50;
  static Color colorHeaders = Colors.amber.shade800;
  static Color colorTexts = Colors.blueGrey.shade50;
  static Color colorButtons = const Color.fromARGB(218, 255, 145, 0);
}

class StyleConstants {
  static BorderRadius border = BorderRadius.circular(20.0);
}

class PayConstants {
  static String publishable_key = 'pk_live_36swzHfwDCLVNpFHwkPODUK9';
  static String private_key =
      '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';
  static String price_id = 'price_1NyJ3KFS1UGHVPAZL8GjuTO0';
}

class AppUrl {
  static String localhost = 'http://localhost:59815';
}

class TextFieldsTexts {
  static const IdeaTextField = 'Describe your vision';
  static const StyleTextField = 'Style it up';
  static const FormatTextField = 'Format page';
  static const TextImageQuality = 'Image quality';
}

List<Map<String, int>> pageSizeOptions = [
  {"": 2},
  {"256x256": 1},
  {"512x512": 2},
  {"1024x1024": 2}
];

List<String> formatOptions = [
  '',
  'Vertical',
  'Portrait',
  'Landscape',
];

final List<Map<String, String>> steps = [
  {
    'title': "Describe Your Vision",
    'description':
        "Imagine guiding your readers through enchanting locales and cultural treasures. Use vivid descriptions to outline your vision for an unforgettable reading experience. ",
    'example':
        "Example: Picture yourself in a bustling market in Marrakech, with the aroma of exotic spices filling the air. Describe the vibrant colors, the sounds of merchants, and the taste of authentic street food."
  },
  {
    'title': "Style it Up",
    'description':
        "Consider the aesthetic of your book. Is it a contemporary masterpiece with modern design elements, or a classic gem with timeless elegance? Define its artistic style.",
    'example':
        "Example: If you're going for a modern style, think of sleek, minimalist cover designs and crisp typography. For a classic touch, imagine ornate borders and vintage illustrations."
  },
  {
    'title': "Diversify Your Portfolio",
    'description':
        "Don't limit yourself to one idea. Expand your repertoire with a range of creative content, from striking visuals to insightful prose.",
    'example':
        "Example: Include a mix of travel anecdotes, captivating photographs, and engaging interviews with local artists. Offer a diverse reading experience."
  },
  {
    'title': "Visualize Your Book",
    'description':
        "Envision the final product. Each idea contributes to a rich tapestry of content, inviting readers on a visual and literary journey.",
    'example':
        "Example: Close your eyes and voilá! Your PDF is ready to download."
  },
  {
    'title': "Publish Your Masterpiece",
    'description':
        "Submit your ideas and witness the transformation. Your vision will be woven into a beautifully designed book, ready to captivate art and leisure enthusiasts worldwide.",
    'example':
        "Example: Once your content is ready, collaborate with talented designers and editors. Imagine holding the printed book in your hands, a culmination of your creative journey."
  },
];

List<String> randomMessages = [
  'Generating your PDF...',
  'Please wait...',
  'Your PDF is on its way...',
  'Your PDF is being created...',
  'Your PDF is being generated...',
  'Preparing your document...',
  'Document is in the works...',
  'Building your PDF...',
  'Sit tight, PDF is coming...',
  'PDF creation in progress...',
  'Creating your content...',
  'PDF is cooking...',
  'Almost there...',
  'Your document is brewing...',
  'Putting together your PDF...',
  'Hold on, PDF is being made...',
  'Your PDF is materializing...',
  'Document magic in progress...',
  'Your PDF is evolving...',
  'Crafting your PDF...',
  'The PDF forge is running...',
  'PDF creation magic happening...',
  'Working on your document...',
  'PDF assembly in progress...',
  'Stay patient, PDF is forming...',
  'Your PDF is shaping up...',
  'Generating your content...',
  'Your PDF is under construction...',
  'Building your masterpiece...',
  'PDF is on its way...',
  'The PDF factory is busy...',
  'Your document is under development...',
  'PDF generation is underway...',
  'Creating your masterpiece...',
  'PDF is being sculpted...',
  'Document crafting in progress...',
  'Hold tight, PDF is emerging...',
  'Your PDF is being woven...',
  'PDF creation artistry in progress...',
  'Building your literary work...',
  'Document composition in progress...',
  'Your PDF is being composed...',
  'PDF is in the making...',
  'Your document is in the oven...',
  'PDF creation process ongoing...',
  'Document construction in progress...',
  'Your PDF is in the works...',
  'The PDF generator is humming...',
  'Creating your document masterpiece...',
  'PDF assembly artistry in progress...',
];

List<String> allStyles = [
  // General Creative Styles
  "Realistic landscape",
  "Abstract art",
  "Fantasy architecture",
  "Surreal nature",
  "Futuristic city",
  "Historical portrait",
  "Whimsical underwater",
  "Minimalist interior",
  "Sci-fi adventure",
  "Dreamy night sky",
  "Magical forest",
  "Abstract geometric",
  "Romantic sunset",
  "Cyberpunk cityscape",
  "Vintage photography",
  "Steampunk machinery",
  "Art deco elegance",
  "Post-apocalyptic world",
  "Cybernetic creatures",
  "Enchanted garden",
  "Industrial urban",
  "Retro futurism",
  "Impressionist painting",
  "Gothic architecture",
  "Pop art explosion",
  "Surrealist dreamscape",
  "Ancient civilization",
  "Neon-lit nightlife",
  "Abstract expressionism",
  "Dystopian future",
  "Renaissance masterpiece",

  // Photographic Attributes and Styles
  "Wide-angle lens view",
  "Bokeh effect portrait",
  "Macro lens close-up",
  "Shallow depth of field",
  "Fish-eye distortion",
  "Long exposure shot",
  "Telephoto lens scene",
  "High dynamic range (HDR)",
  "Tilt-shift miniature",
  "Low-key lighting",
  "High-key portrait",
  "Silhouette photography",
  "Panning motion blur",
  "Cinematic 16:9 ratio",
  "Anamorphic lens flare",
  "Infrared photography",
  "Double exposure art",
  "Nighttime cityscape",
  "Slow shutter speed",
  "Time-lapse sequence",
  "360-degree panorama",
  "Astrophotography",
  "Pinhole camera effect",
  "Vintage film grain",
  "Polaroid instant shot",
  "Vignette frame style",
  "Medium format film",
  "Ultra-wide angle shot",
  "Bokeh background",
  "Monochrome portrait",
  "Lomography aesthetic",
  "Solarized image",
  "Holga toy camera",
  "Lensbaby creative",
  "Paparazzi frenzy",
  "In-camera multiple exposure",

  // Combined Prompts (You can add more)
  "A wide-angle lens view of a bustling cityscape",
  "A portrait with bokeh effect and shallow depth of field",
  "A macro lens close-up of intricate details",
  "An infrared photography scene with a fish-eye distortion",
  "A cinematic 16:9 ratio shot of a futuristic city",
  "A double exposure art piece with a vintage film grain",
  "A nighttime cityscape with high-key lighting",
  "An astrophotography shot of a starry night",
];

// You can use elements from the 'allStyles' list to create prompts for DALL·E 2.

