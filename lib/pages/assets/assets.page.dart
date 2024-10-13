import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_bar.dart';
import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../styles/styles.dart';
import 'widgets/widgets.dart';

class AssetsPage extends GetView<AssetTreeController> {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'Assets'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.list(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Bucar Ativo ou Local',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.gray500,
                        weight: 12,
                      ),
                      filled: true,
                      fillColor: AppColors.gray100,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      hintStyle: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    controller: controller.filters.query,
                    style: AppTextStyles.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Obx(
                        () => ButtonCheckbox(
                          selected: controller.filters.sensorType.value,
                          value: SensorType.energy,
                          onChanged: (value) {
                            controller.filters.sensorType.value = value;
                          },
                          label: 'Sensor de Energia',
                          icon: Icons.bolt_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(
                        () => ButtonCheckbox(
                          selected: controller.filters.sensorStatus.value,
                          value: SensorStatus.alert,
                          onChanged: (value) {
                            controller.filters.sensorStatus.value = value;
                          },
                          label: 'Crítico',
                          icon: Icons.error_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                color: AppColors.gray200,
                height: 1,
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: TreeView(),
            ),
          ],
        );
      }),
    );
  }
}
