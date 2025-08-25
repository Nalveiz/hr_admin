/// DTO for creating a new company
class CreateCompanyDto {
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;

  const CreateCompanyDto({
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
    };
  }
}

/// DTO for updating a company
class UpdateCompanyDto {
  final String? name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final bool? valid;

  const UpdateCompanyDto({
    this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.valid,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (valid != null) 'valid': valid,
    };
  }
}

/// DTO for company filtering parameters
class CompanyFilterParams {
  final String? search;
  final int? page;
  final int? size;
  final String? sortBy;
  final String? sortDirection;
  

  const CompanyFilterParams({
    this.search,
    this.page,
    this.size,
    this.sortBy,
    this.sortDirection,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      if (search != null && search!.isNotEmpty) 'search': search,
      if (page != null) 'page': page,
      if (size != null) 'size': size,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortDirection != null) 'sortDirection': sortDirection,
    };
  }
}
