#include "calculatorbackend.h"

#include <QDebug>

CalculatorBackend::CalculatorBackend(QObject *parent) : QObject{parent} {}

void CalculatorBackend::digitPressed(int digit) {

  QString label = QString::number(digit);

  if (m_isNewNumber) {
    m_displayValue = label;
    m_isNewNumber = false;
  } else if (m_displayValue == "0") {
    m_displayValue = label;
  } else {
    m_displayValue += label;
  }
  emit displayValueChanged();
}

void CalculatorBackend::clearAll() {
  m_displayValue = "0";
  m_currentOperand = "";
  m_previousValue = 0;
  m_isNewNumber = false;
  emit displayValueChanged();
  emit currentOperandChanged();
}

void CalculatorBackend::clearLast() {
  m_displayValue.chop(1);
  if (m_displayValue.isEmpty() || m_displayValue == "-") {
    m_displayValue = "0";
  }
  emit displayValueChanged();
}

void CalculatorBackend::operatorPressed(const QString &op) {
  // Если уже есть оператор и пользователь ввёл новое число — вычисляем промежуточный результат
  if (!m_currentOperand.isEmpty() && !m_isNewNumber) {
    equalPressed();
  }
  m_previousValue = m_displayValue.toDouble();
  m_currentOperand = op;
  m_isNewNumber = true;
  emit displayValueChanged();
  emit currentOperandChanged();
}

void CalculatorBackend::equalPressed() {
  if (m_currentOperand.isEmpty()) {
    return;
  }

  double currentValue = m_displayValue.toDouble();
  double result = 0;

  if (m_currentOperand == "+") {
    result = m_previousValue + currentValue;
  } else if (m_currentOperand == "−") {
    result = m_previousValue - currentValue;
  } else if (m_currentOperand == "×") {
    result = m_previousValue * currentValue;
  } else if (m_currentOperand == "÷" && currentValue != 0) {
    result = m_previousValue / currentValue;
  } else if (m_currentOperand == "÷" && currentValue == 0) {
    m_displayValue = "Error";
    m_currentOperand = "";
    emit currentOperandChanged();
    emit displayValueChanged();
    return;
  }

  m_displayValue = QString::number(result);
  m_currentOperand = "";
  emit currentOperandChanged();
  emit displayValueChanged();
}

void CalculatorBackend::dotPressed() {
  if (m_displayValue.contains('.')) {
    return;
  }
  m_displayValue.append('.');
  emit displayValueChanged();
}

void CalculatorBackend::changeSign() {
  if (m_displayValue == "0" || m_displayValue.isEmpty()) {
    return;
  }
  if (m_displayValue.startsWith('-')) {
    m_displayValue.remove(0, 1);
  } else {
    m_displayValue.prepend('-');
  }
  emit displayValueChanged();
}