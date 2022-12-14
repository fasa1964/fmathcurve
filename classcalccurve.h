#ifndef CLASSCALCCURVE_H
#define CLASSCALCCURVE_H

#include <QObject>
#include <QQmlProperties>

#include <QPointF>

class ClassCalcCurve : public QObject
{
    Q_OBJECT
    QML_ELEMENT

public:
    explicit ClassCalcCurve(QObject *parent = nullptr);

    Q_INVOKABLE double getAngle(QPointF p1, QPointF p2);
    Q_INVOKABLE double getVorlaufTemperatur(double value);
    Q_INVOKABLE double getAussenTemperatur(double value);


signals:


private:

    QMap<double, double> tempMap;

};

#endif // CLASSCALCCURVE_H
