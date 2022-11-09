#include "classcalccurve.h"
#include "qpoint.h"

#include <QtMath>

#include <QDebug>

#define PI 3.14159265

ClassCalcCurve::ClassCalcCurve(QObject *parent)
    : QObject{parent}
{

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


    return vt;
}
