import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:iconly/iconly.dart';
import '../../locale/l10n/app_locale.dart';
import '../../repos/authentication/authentication_repository.dart';
import '../../routes/app_routes.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthenticationRepository>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(context.setHeight(7)),
        child: Padding(
          padding: EdgeInsets.only(top: context.setHeight(3)),
          child: AppBar(
            title: Text(
              AppLocale.of(context)!.titleHome,
              style: TextStyle(
                color: const Color(0xFF1D1B20),
                fontSize: context.setWidth(5),
                fontWeight: FontWeight.w400,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          backgroundDecoration(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: context.setHeight(0)),
              child: Column(
                children: [
                  staticContent(context),
                  Expanded(
                    child: tabSection(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, authRepo),
    );
  }

  Widget backgroundDecoration() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget staticContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.setHeight(2),
        horizontal: context.setWidth(2),
      ),
      child: Column(
        children: [
          searchAndFilterSection(context),
          SizedBox(height: context.setHeight(1)),
          buttonRow(context),
        ],
      ),
    );
  }

  Widget buttonRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => showSpecializationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.setWidth(5)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocale.of(context)!.specializationButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.setWidth(4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: context.setWidth(1)),
                    Icon(Icons.add, size: context.setWidth(4), color: Colors.white),
                  ],
                ),
              ),
              // Location Button
              ElevatedButton(
                onPressed: () => showLocationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6750A4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.setWidth(5)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocale.of(context)!.locationButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.setWidth(4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: context.setWidth(1)),
                    Icon(Icons.add, size: context.setWidth(4), color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: context.setWidth(2),
                      runSpacing: context.setHeight(1),
                      children: state.selectedSpecializations.map((specialization) {
                        return Chip(
                          label: Text(
                            specialization,
                            style: TextStyle(
                              color: const Color(0xFF6750A4),
                              fontSize: context.setWidth(3.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: const Color(0xFFE8DEF8),
                          deleteIcon: Icon(Icons.close, size: context.setWidth(4), color: const Color(0xFF6750A4)),
                          onDeleted: () {
                            context.read<HomeBloc>().add(ToggleSpecialization(specialization));
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return Wrap(
                      spacing: context.setWidth(2),
                      runSpacing: context.setHeight(1),
                      children: state.selectedCities.map((city) {
                        return Chip(
                          label: Text(
                            city,
                            style: TextStyle(
                              color: const Color(0xFF6750A4),
                              fontSize: context.setWidth(3.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: const Color(0xFFE8DEF8),
                          deleteIcon: Icon(Icons.close, size: context.setWidth(4), color: const Color(0xFF6750A4)),
                          onDeleted: () {
                            context.read<HomeBloc>().add(ToggleCity(city));
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchAndFilterSection(BuildContext context) {
    return Container(
      width: context.setWidth(90),
      height: context.setHeight(6),
      margin: EdgeInsets.symmetric(horizontal: context.setWidth(5), vertical: context.setHeight(1)),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6F0),
        borderRadius: BorderRadius.circular(context.setWidth(8)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(IconlyBold.filter_2, color: const Color(0xFF49454F), size: context.setWidth(6)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocale.of(context)!.clearFiltersTitle),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppLocale.of(context)!.clearAll),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocale.of(context)!.confirm),
                                content: Text(AppLocale.of(context)!.clearAllFiltersConfirmation),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocale.of(context)!.yes),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      context.read<HomeBloc>().add(ClearFilters());
                                      searchController.clear();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(AppLocale.of(context)!.no),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      TextButton(
                        child: Text(AppLocale.of(context)!.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: AppLocale.of(context)!.findDoctorPlaceholder,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: const Color(0x6649454F),
                      fontSize: context.setWidth(5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<HomeBloc>().add(UpdateSearchText(value.trim().toLowerCase()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF49454F), size: context.setWidth(6)),
                  onPressed: () {
                    context.read<HomeBloc>().add(UpdateSearchText(searchController.text.trim().toLowerCase()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF6750A4),
                  width: context.setWidth(0.7),
                ),
              ),
            ),
            labelColor: const Color(0xFF1D1B20),
            unselectedLabelColor: const Color(0xFF49454F),
            labelStyle: TextStyle(
              fontSize: context.setWidth(5),
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: AppLocale.of(context)!.doctorsTab),
              Tab(text: AppLocale.of(context)!.institutionsTab),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                doctorList(context),
                institutionList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget doctorList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.doctors.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: state.doctors.length,
          itemBuilder: (context, index) {
            var doc = state.doctors[index];
            return Container(
              width: context.setWidth(100),
              height: context.setHeight(20),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.setHeight(1),
                        horizontal: context.setWidth(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: context.setWidth(15),
                            height: context.setWidth(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(doc.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: context.setWidth(5)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.name,
                                  style: TextStyle(
                                    color: const Color(0xFF6750A4),
                                    fontSize: context.setWidth(4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  doc.speciality,
                                  style: TextStyle(
                                    fontSize: context.setWidth(3.5),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${AppLocale.of(context)!.phoneNumberLabel}: ${doc.phone}',
                                  style: TextStyle(
                                    fontSize: context.setWidth(3),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.setWidth(7)),
                    child: Divider(
                      height: context.setHeight(1),
                      thickness: 2,
                      color: const Color(0xFFCAC4D0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget institutionList(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.institutions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: state.institutions.length,
          itemBuilder: (context, index) {
            var institution = state.institutions[index];
            var imageUrl = institution.imageUrl;
            var name = institution.name;
            var specialtiesDescription = institution.specialities.isNotEmpty
                ? institution.specialities.join(', ')
                : AppLocale.of(context)!.noSpecialtiesListed;
            var city = institution.city;

            return Container(
              width: context.setWidth(100),
              height: context.setHeight(20),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.setHeight(1),
                        horizontal: context.setWidth(5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: context.setWidth(15),
                            height: context.setWidth(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: context.setWidth(5)),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: const Color(0xFF6750A4),
                                    fontSize: context.setWidth(4),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  city,
                                  style: TextStyle(
                                    fontSize: context.setWidth(3.5),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  specialtiesDescription,
                                  style: TextStyle(
                                    fontSize: context.setWidth(3),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.setWidth(7)),
                    child: Divider(
                      height: context.setHeight(1),
                      thickness: 2,
                      color: const Color(0xFFCAC4D0),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showSpecializationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final filteredSpecializations = state.specializations
                .where((specialization) => !state.selectedSpecializations.contains(specialization))
                .where((specialization) =>
                specialization.toLowerCase().contains(state.specializationSearchQuery.toLowerCase()))
                .toList();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.setWidth(5)),
              ),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(5)),
                constraints: BoxConstraints(
                  maxHeight: context.setHeight(80),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: context.setHeight(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                context.read<HomeBloc>().add(UpdateSpecializationSearchQuery(value));
                              },
                              decoration: InputDecoration(
                                hintText: AppLocale.of(context)!.search,
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF49454F)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(context.setWidth(4)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: context.setHeight(1),
                                  horizontal: context.setWidth(4),
                                ),
                                hintStyle: TextStyle(
                                  color: const Color(0xFF49454F),
                                  fontSize: context.setWidth(4),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: const Color(0xFF49454F), size: context.setWidth(5)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: context.setWidth(2),
                          runSpacing: context.setHeight(1),
                          children: filteredSpecializations.map((specialization) {
                            return FilterChip(
                              label: Text(
                                specialization,
                                style: TextStyle(
                                  color: const Color(0xFF6750A4),
                                  fontSize: context.setWidth(3.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: const Color(0xFFE8DEF8),
                              shape: const StadiumBorder(),
                              onSelected: (bool selected) {
                                if (selected) {
                                  context.read<HomeBloc>().add(ToggleSpecialization(specialization));
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final filteredCities = state.cities
                .where((city) => !state.selectedCities.contains(city))
                .where((city) =>
                city.toLowerCase().contains(state.citySearchQuery.toLowerCase()))
                .toList();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.setWidth(5)),
              ),
              child: Container(
                padding: EdgeInsets.all(context.setWidth(5)),
                constraints: BoxConstraints(
                  maxHeight: context.setHeight(80),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: context.setHeight(2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                context.read<HomeBloc>().add(UpdateCitySearchQuery(value));
                              },
                              decoration: InputDecoration(
                                hintText: AppLocale.of(context)!.search,
                                prefixIcon: const Icon(Icons.search, color: Color(0xFF49454F)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(context.setWidth(4)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: context.setHeight(1),
                                  horizontal: context.setWidth(4),
                                ),
                                hintStyle: TextStyle(
                                  color: const Color(0xFF49454F),
                                  fontSize: context.setWidth(4),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: const Color(0xFF49454F), size: context.setWidth(5)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: context.setWidth(2),
                          runSpacing: context.setHeight(1),
                          children: filteredCities.map((city) {
                            return FilterChip(
                              label: Text(
                                city,
                                style: TextStyle(
                                  color: const Color(0xFF6750A4),
                                  fontSize: context.setWidth(3.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: const Color(0xFFE8DEF8),
                              shape: const StadiumBorder(),
                              onSelected: (bool selected) {
                                if (selected) {
                                  context.read<HomeBloc>().add(ToggleCity(city));
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, AuthenticationRepository authRepo) {
    return Container(
      height: context.setHeight(8),
      decoration: const BoxDecoration(color: Color(0xFFECE6F0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildNavItem(IconlyBold.paper, AppLocale.of(context)!.trials, false, context),
          buildNavItem(IconlyBold.activity, AppLocale.of(context)!.data, false, context),
          buildNavItem(IconlyBold.home, AppLocale.of(context)!.titleHome, true, context),
          buildNavItem(IconlyBold.message, AppLocale.of(context)!.messages, false, context),
          buildNavItem(IconlyBold.profile, AppLocale.of(context)!.profile, false, context, onTap: () async {
            try {
              await authRepo.logOut();
              Navigator.pushReplacementNamed(context, AppRoutes.start);
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocale.of(context)!.logoutFailed}: $error')));
            }
          }),
        ],
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, bool isActive, BuildContext context, {void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: context.setWidth(7),
            color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F),
          ),
          SizedBox(height: context.setWidth(1)),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF6750A4) : const Color(0xFF49454F),
              fontSize: context.setWidth(3),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}