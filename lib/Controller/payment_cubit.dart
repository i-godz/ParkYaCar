import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'payment_cubit_state.dart';


class Payment_Cubit extends Cubit<PaymentCubitState> {
Payment_Cubit() : super(PaymentCubitInitial());
static Payment_Cubit get(context) => BlocProvider.of(context);


}