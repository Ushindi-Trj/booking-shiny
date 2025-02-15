import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booking_shiny/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:booking_shiny/data/models/models.dart';
import 'package:booking_shiny/backend/cubit/cubits.dart';

import 'package:booking_shiny/frontend/widgets/widgets.dart';
import 'package:booking_shiny/frontend/components/components.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayWidget(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 64,
          centerTitle: true,
          leading: const PopButtonWidget(),
          title: Text(
            'Payment Methods',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<UserCubit, UserState>(
          bloc: BlocProvider.of<UserCubit>(context)..fecthCardsRequest(),
          buildWhen: (_, current) => current is FetchCardsError || current is FetchCardsDone,
          listenWhen: (_, current) {
            return 
              current is FetchCardsLoading ||
              current is FetchCardsError ||
              current is FetchCardsDone
            ;
          },
          listener: (context, state) {
            if (state is FetchCardsLoading) {
              context.loaderOverlay.show();
            } else if (state is FetchCardsError) {
              context.loaderOverlay.hide();
              SnackBarWidget.showSnackbarError(context: context, message: state.message);
            } else if (state is FetchCardsDone) {
              context.loaderOverlay.hide();
            }
          },
          builder: (context, state) {
            if (state is FetchCardsError) {
              return Center(child: Text(
                state.message,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Support.red2),
              ));
            } else if (state is FetchCardsDone) {
              final paymentMethods = state.paymentMethods;

              if (paymentMethods.isNotEmpty) {
                return _ReorderablePaymentMethods(methods: paymentMethods);
              }
              return Center(
                child: Text(
                  'Add a payment method',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Support.red2
                  ),
                ),
              );
            }
            return const ProgressWidget();
          }
        ),
    
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButtonWidget(
            text: 'Add Payment Method',
            onClicked: () {
              context.push(Routes.addPaymentMethod.path);
            }
          ),
        ),
      ),
    );
  }
}


class _ReorderablePaymentMethods extends StatefulWidget {
  const _ReorderablePaymentMethods({required this.methods});

  final List<PaymentMethodModel> methods;

  @override
  State<_ReorderablePaymentMethods> createState() => __ReorderablePaymentMethodsState();
}

class __ReorderablePaymentMethodsState extends State<_ReorderablePaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) {
        return 
          current is SetDefaultCardLoading ||
          current is SetDefaultCardDone ||
          current is SetDefaultCardError
        ;
      },
      listener: (context, state) {
        if (state is SetDefaultCardLoading) {
          context.loaderOverlay.show();
        } else if (state is SetDefaultCardError) {
          context.loaderOverlay.hide();
          SnackBarWidget.showSnackbarError(context: context, message: state.message);
        } else if (state is SetDefaultCardDone) {
          context.loaderOverlay.hide();
          context.read<UserCubit>().fecthCardsRequest();
        } 
      },
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        onReorder: (oldIndex, newIndex) {
          if (oldIndex != newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = widget.methods.removeAt(oldIndex);
              widget.methods.insert(newIndex, item);

              //  Update the deault payment method in stripe
              context.read<UserCubit>().setDeaultCardRequest(item.id);
            });
          }
        },
        children: [
          for (var item in widget.methods)
            PaymentMthodItem(
              key: ValueKey<String>(item.id),
              card: item,
              onDismissed: () => setState(() {
                widget.methods.remove(item);
              }),
            )
        ],
      ),
    );
  }
}