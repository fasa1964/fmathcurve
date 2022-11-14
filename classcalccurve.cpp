#include "classcalccurve.h"
#include "qpoint.h"

#include <QtMath>

#include <QDebug>

#define PI 3.14159265

ClassCalcCurve::ClassCalcCurve(QObject *parent)
    : QObject{parent}
{

    tempMap.insert(0,20);
    tempMap.insert(1,15);
    tempMap.insert(2,10);
    tempMap.insert(3,5);
    tempMap.insert(4,0);
    tempMap.insert(5,-5);
    tempMap.insert(6,-10);
    tempMap.insert(7,-15);
    tempMap.insert(8,-20);

}

double ClassCalcCurve::getAngle(QPointF p1, QPointF p2)
{
    double angle = 0.0;

    double dy = p2.y() - p1.y();
    double dx = p2.x() - p1.x();

    angle = atan2(dy, dx) * 180 / PI;


    return angle;

}

double ClassCalcCurve::getVorlaufTemperatur(double value)
{
    double vt = 0.0;

    vt = 5 * value + 20;


    return vt;
}

double ClassCalcCurve::getAussenTemperatur(double value)
{
    double at = 0.0;

    at = value * 5 - 20;

    return -at;
}
