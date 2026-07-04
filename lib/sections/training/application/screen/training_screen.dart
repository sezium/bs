import 'package:bs/base/application/screen/base_screen.dart';
import 'package:bs/core/widgets/colors.dart';
import 'package:bs/sections/cards/application/screen/cards_screen.dart';
import 'package:bs/sections/images/application/screen/images_screen.dart';
import 'package:bs/sections/international_names/application/screen/international_names_screen.dart';
import 'package:bs/sections/names/application/screen/names_screen.dart';
import 'package:bs/sections/numbers/application/screen/numbers_screen.dart';
import 'package:bs/sections/training/application/bloc/training_bloc.dart';
import 'package:bs/sections/training/application/screen/ui/training_card.dart';
import 'package:bs/sections/words/application/screen/words_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainingScreen extends SingleBlocScreen<TrainingBloc> {
  TrainingScreen({super.key}) : super(bloc: TrainingBloc());
  static String get route => '/training';

  Widget page(
    BuildContext context, {
    WrapAlignment alignment = WrapAlignment.center,
    double maxWidth = double.infinity,
  }) {
    return Scaffold(
      backgroundColor: BsColors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Solo Training',
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: BsColors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: alignment,
                            spacing: 20,
                            runSpacing: 20,
                            children: [
                              TrainingCard(
                                title: 'Cards',
                                label: 'Memorize playing cards.',
                                color: BsColors.red,
                                assetsPath: 'assets/event_cards.png',
                                route: CardsScreen.route,
                              ),
                              TrainingCard(
                                title: 'Images',
                                label: 'Memorize random images.',
                                color: BsColors.yellow,
                                assetsPath: 'assets/event_images.png',
                                route: ImagesScreen.route,
                              ),
                              TrainingCard(
                                title: 'International Names',
                                label: "Memorize international names.",
                                color: BsColors.olive,
                                assetsPath: 'assets/event_international.png',
                                route: InternationalNamesScreen.route,
                              ),
                              TrainingCard(
                                title: 'Names',
                                label: "Memorize people's names.",
                                color: BsColors.green,
                                assetsPath: 'assets/event_names.png',
                                route: NamesScreen.route,
                              ),
                              TrainingCard(
                                title: 'Numbers',
                                label: 'Memorize random numbers.',
                                color: BsColors.blue,
                                assetsPath: 'assets/event_numbers.png',
                                route: NumbersScreen.route,
                              ),
                              TrainingCard(
                                title: 'Words',
                                label: 'Memorize random words.',
                                color: BsColors.purple,
                                assetsPath: 'assets/event_words.png',
                                route: WordsScreen.route,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget mobile(BuildContext context) => page(context, alignment: WrapAlignment.center, maxWidth: double.infinity);

  @override
  Widget tablet(BuildContext context) => page(context, alignment: WrapAlignment.center, maxWidth: 1000);

  @override
  Widget desktop(BuildContext context) => page(context, alignment: WrapAlignment.center, maxWidth: 1000);
}
