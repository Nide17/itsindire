import 'package:flutter/material.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/providers/quiz_score_provider.dart';

class CustomRadioButton extends StatefulWidget {
  final bool isSelected;
  final ValueChanged<bool?> onChanged;
  final bool isThisCorrect;
  final List<ScoreQuestion>? scoreQuestions;
  final QuizScoreProvider? scoreProviderModel;
  final OptionPopQn? option;
  final PopQuestionModel? currentQuestion;
  final int? choosenOption;
  final bool? isAnswered;
  final bool? isAnswerCorrect; // NULL AT FIRST

  const CustomRadioButton({
    super.key,

    // POP QUESTIONS
    required this.isSelected,
    required this.isThisCorrect,
    required this.onChanged,
    this.scoreQuestions,
    this.scoreProviderModel,
    this.option,
    this.currentQuestion,

    // SCORE QUESTIONS
    this.choosenOption,
    this.isAnswered,
    this.isAnswerCorrect,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  @override
  Widget build(BuildContext context) {
    bool? isThisCorrect = widget.isAnswered == null
        ? widget.isThisCorrect
        : (widget.isAnswered == true &&
                widget.option != null &&
                widget.option!.id == widget.choosenOption &&
                widget.isAnswerCorrect == true)
            ? true
            : null;

    bool isSelected = widget.isAnswered == null
        ? widget.isSelected
        : (widget.isAnswered == true && widget.option != null && widget.option!.id == widget.choosenOption)
            ? true
            : false;

    return GestureDetector(
      onTap: () {
        widget.onChanged(!isSelected);
        if (widget.scoreProviderModel != null) {
          for (var element in widget.scoreProviderModel!.quizScore.questions) {
            if (element.popQuestion.id == widget.currentQuestion!.id) {
              element.isAnswered = true;
              element.setChoosenOption(widget.option!.id);
              element.setIsAnswerCorrect(widget.option!.id ==
                  widget.currentQuestion!.getCorrectOptionId());
            }
          }
        }
      },
      child: Column(
        children: [
          _buildOptionContainer(context, isSelected, isThisCorrect),
          if (isSelected) _buildDescriptionSubtitle(context, isThisCorrect),
        ],
      ),
    );
  }

  Widget _buildOptionContainer(BuildContext context, bool isSelected, bool? isThisCorrect) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.006),
      margin: EdgeInsets.fromLTRB(
          0, 0, 0, MediaQuery.of(context).size.height * 0.015),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? getDisplayColor(isThisCorrect)
                : Colors.grey.withValues(alpha: 0.4),
            offset: const Offset(0, 1),
            blurRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isSelected ? getDisplayColor(isThisCorrect) : Colors.grey,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.height * 0.023,
            height: MediaQuery.of(context).size.height * 0.023,
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.004,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey,
                width: MediaQuery.of(context).size.height * 0.002,
              ),
            ),
            child: isSelected
                ? Icon(
                    isThisCorrect == true
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: isThisCorrect == true
                        ? const Color(0xFF00A651)
                        : Colors.red,
                    size: MediaQuery.of(context).size.height * 0.018,
                  )
                : Container(),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Expanded(
            child: Text(
              widget.option == null ? '' : widget.option!.text ?? '',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.017,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSubtitle(BuildContext context, bool? isThisCorrect) {
    return Wrap(
      children: [
        isThisCorrect == true
            ? Text('Wabikoze! ',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: const Color(0xFF00A651),
                    fontSize: MediaQuery.of(context).size.height * 0.014,
                    fontWeight: FontWeight.bold))
            : Align(
                alignment: Alignment.topLeft,
                child: Text('Ongera ugerageze!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: MediaQuery.of(context).size.height * 0.014,
                        fontWeight: FontWeight.bold)),
              ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.01),
          child: Text(
            isThisCorrect == true &&
                    widget.option != null &&
                    widget.option!.description != null
                ? widget.option!.description ?? ''
                : '',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.014,
              color: Colors.black.withValues(alpha: 0.9),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
      ],
    );
  }

  Color getDisplayColor(bool? isThisCorrect) {
    if (isThisCorrect != null) {
      if (isThisCorrect == true) {
        return const Color(0xFF00A651);
      } else if (isThisCorrect == false) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    } else {
      return Colors.grey;
    }
  }
}
