package Model;

public class ActivityDate {
    private int day;
    private int month;
    private int year;
    private String monthName;
    private String dateKey; // yyyy-MM-dd

    public ActivityDate(int day, int month, int year, String monthName, String dateKey) {
        this.day = day;
        this.month = month;
        this.year = year;
        this.monthName = monthName;
        this.dateKey = dateKey;
    }

    public int getDay() { return day; }
    public int getMonth() { return month; }
    public int getYear() { return year; }
    public String getMonthName() { return monthName; }
    public String getDateKey() { return dateKey; }
}