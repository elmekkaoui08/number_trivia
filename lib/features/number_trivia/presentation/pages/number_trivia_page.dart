import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/widgets/number_trivia_input.dart';
import 'package:number_trivia/injection_container.dart';
import 'package:number_trivia/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Number'),
      ),
      body: Container(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) => _getApproperiateWidget(state),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    NumberTriviaInput(
                      controller: _controller,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedButton(
                          buttonText: 'Concrete',
                          onPress: () {
                            BlocProvider.of<NumberTriviaBloc>(context).add(
                                GetConcreteNumberTriviaEvent(_controller.text));
                            _controller.text = '';
                          },
                        ),
                        RoundedButton(
                          buttonText: 'Random',
                          onPress: () {
                            context
                                .bloc<NumberTriviaBloc>()
                                .add(GetRandomNumberTriviaEvent());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getApproperiateWidget(NumberTriviaState state) {
    if (state is NumberTriviaInitial) {
      return Container(
        child: Center(
          child: Text(
            'Search a trivia',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else if (state is NumberTriviaLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is NumberTriviaLoaded) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
          ),
          child: Center(
            child: Text(
              state.numberTriviaEntity.textTrivia,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else if (state is NumberTriviaError) {
      return Container(
        child: Center(
          child: Text(
            state.errMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key,
    @required this.onPress,
    @required this.buttonText,
  }) : super(key: key);

  final Function onPress;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      onPressed: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        height: size.height * .07,
        width: size.width * .3,
        decoration: BoxDecoration(
          color: Colors.green.shade500,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
