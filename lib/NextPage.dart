import 'package:flutter/material.dart';

class Nextpage extends StatefulWidget {
  const Nextpage({super.key});

  @override
  State<Nextpage> createState() => _NextpageState();
}

class _NextpageState extends State<Nextpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flower Page"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.white, width: 2),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flower Image
                  Image.network(
                    'https://images.unsplash.com/photo-1490750967868-88aa4486c946',
                    height: 500,
                    width: 400,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Beautiful Flower",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Beautiful Flower\nFlowers are among the most attractive creations of nature. They add beauty, fragrance, and color to gardens and natural landscapes. Flowers play an important role in plant reproduction by attracting pollinators such as bees, butterflies, and birds. Many flowers are used for decoration, religious ceremonies, perfumes, medicines, and gifts. Different flowers symbolize different emotions such as love, friendship, purity, and happiness. Their vibrant colors and pleasant fragrance make them popular worldwide as symbols of beauty and positivity.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
