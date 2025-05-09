import 'package:fluent_ui/fluent_ui.dart';

import 'package:otoscopia/src/core/core.dart';

import 'admin_routes.dart';
import 'guest_routes.dart';
import 'patient_routes.dart';

Map<String, WidgetBuilder> createRoutes(
  bool isAuthenticated,
  DeviceType platform,
  UserRole? role,
) {
  if (!isAuthenticated) return GuestRoutes.getRoutes();

  switch (role) {
    case UserRole.admin:
      return AdminRoutes.getRoutes(platform);
    case UserRole.doctor || UserRole.nurse:
      return {'/': (context) => const AppNavigation()};
    case UserRole.patient:
      return PatientRoutes.getRoutes(platform);
    default:
      return GuestRoutes.getRoutes();
  }
}
