import 'package:flutter/material.dart';

class PaginationLoaderWidget extends StatelessWidget {
  final bool isLoading;

  const PaginationLoaderWidget({Key? key, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.bounceInOut,
      padding: const EdgeInsets.all(10),
      height: isLoading ? 55.0 : 0,
      color: isLoading ? Theme.of(context).cardColor : Colors.transparent,
      duration: const Duration(milliseconds: 300),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
