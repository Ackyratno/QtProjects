#ifndef CALCULATORBACKEND_H
#define CALCULATORBACKEND_H

#include <QObject>
#include <QtQml/qqml.h>

class CalculatorBackend : public QObject {
  Q_OBJECT
  QML_ELEMENT

  Q_PROPERTY(QString displayValue READ displayValue NOTIFY displayValueChanged)
  Q_PROPERTY(
      QString currentOperand READ currentOperand NOTIFY currentOperandChanged)

public:
  explicit CalculatorBackend(QObject *parent = nullptr);

  Q_INVOKABLE void digitPressed(int digit);

  Q_INVOKABLE void operatorPressed(const QString &op);

  Q_INVOKABLE void equalPressed();

  Q_INVOKABLE void clearAll();

  Q_INVOKABLE void clearLast();

  Q_INVOKABLE void dotPressed();

  Q_INVOKABLE void changeSign();

  QString displayValue() const { return m_displayValue; }
  QString currentOperand() const { return m_currentOperand; }

signals:
  void displayValueChanged();
  void currentOperandChanged();

private:
  QString m_displayValue = "0";
  QString m_currentOperand = "";
  double m_previousValue = 0;
  bool m_isNewNumber = false;
};

#endif // CALCULATORBACKEND_H
