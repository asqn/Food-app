import 'package:flutter/material.dart';
import 'package:foody/data/data.dart';
import 'package:foody/utils/constants.dart';
import 'package:foody/widgets/price_shimmer.dart';
import '../models/order.dart';
import '../widgets/cart_shimmer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  _buildCartItem(Order order) {
    return Container(
      height: 130.0,
      margin: const EdgeInsets.all(12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(order.food!.imageUrl!))),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.food!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        order.restaurant!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 90.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 0.6, color: Colors.black54)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "-",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                            const SizedBox(
                              width: 30, // Réduit la taille de l'espacement
                            ),
                            Text(
                              order.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(
                              width: 10, // Réduit la taille de l'espacement
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                "+",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Text(
          "${order.food!.price!.toString()}\$",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ]),
    );
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var order in currentUser.cart!) {
      totalPrice += order.quantity! * order.food!.price!;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cart (${currentUser.cart!.length})'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index < currentUser.cart!.length) {
                  Order order = currentUser.cart![index];
                  return isLoading
                      ? const CartItemShimmer()
                      : _buildCartItem(order);
                }
                return isLoading
                    ? const PriceShimmer()
                    : Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Estimated Delivery Time:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "30min",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "${totalPrice.toStringAsFixed(2)}\$",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 1,
                  color: Colors.grey,
                );
              },
              itemCount: currentUser.cart!.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
