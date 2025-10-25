class RoleModel {
  final String id;
  final String name;
  final List<String>? permissions;

  RoleModel({
    required this.id,
    required this.name,
    this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    print('🔄 Parsing role JSON: $json');
    
    try {
      // Handle different ID formats
      final id = json['_id']?.toString() ?? 
                 json['id']?.toString() ?? 
                 '';
      
      if (id.isEmpty) {
        print('⚠️  Role has empty ID: $json');
      }
      
      // Handle name
      final name = json['name']?.toString() ?? 
                   json['roleName']?.toString() ?? 
                   'Unknown Role';
      
      if (name == 'Unknown Role') {
        print('⚠️  Role has unknown name: $json');
      }
      
      // Handle permissions
      List<String>? permissions;
      if (json['permissions'] != null && json['permissions'] is List) {
        permissions = (json['permissions'] as List)
            .map((item) => item?.toString() ?? '')
            .where((item) => item.isNotEmpty)
            .toList();
      }
      
      print('✅ Parsed role: $name (ID: $id) - Permissions: $permissions');
      
      return RoleModel(
        id: id,
        name: name,
        permissions: permissions,
      );
    } catch (e) {
      print('❌ Error parsing role JSON: $e');
      print('❌ Problematic JSON: $json');
      // Return a default role instead of throwing to avoid breaking the entire list
      return RoleModel(
        id: 'error-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Error Role',
        permissions: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': permissions,
    };
  }
}