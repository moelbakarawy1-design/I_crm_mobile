import '../../featuer/Auth/data/model/auth_models.dart';
import '../../featuer/role/helper/enum_permission.dart';

class PermissionManager {
  static bool can(UserModel? user, Permission permission) {
    if (user == null) return false;
    return user.role?.permissions.contains(permission) ??
        false ||
        user.role!.permissions.contains(Permission.ADMIN) ;
        
  }
}
