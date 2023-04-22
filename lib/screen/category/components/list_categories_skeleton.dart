import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ListCategoriesSkeleton extends StatelessWidget {
  const ListCategoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: 12,
      shrinkWrap: true,
      itemBuilder: (context, index) => const CategorySkeleton(),
    );
  }
}

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Row(
            children: [
              const SkeletonAvatar(
                  style: SkeletonAvatarStyle(width: 30, height: 30)),
              const SizedBox(width: 20),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 20,
                  width: 150,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const Spacer(),
          const SkeletonAvatar(
              style: SkeletonAvatarStyle(width: 20, height: 15)),
        ],
      ),
    );
  }
}
