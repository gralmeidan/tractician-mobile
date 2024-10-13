import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/app_bar.dart';
import '../../models/models.dart';
import '../../routes/routes.dart';
import '../../services/services.dart';
import '../../styles/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Company>> future;

  @override
  void initState() {
    super.initState();

    future = TracticianService.to.getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(canPop: false),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 30,
            ),
            itemBuilder: (context, index) {
              final company = snapshot.data![index];

              return ElevatedButton(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.assets,
                    arguments: company,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColors.primary,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 32,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.company),
                    const SizedBox(width: 16),
                    Text(
                      company.name,
                      style: AppTextStyles.button,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 40);
            },
          );
        },
      ),
    );
  }
}
