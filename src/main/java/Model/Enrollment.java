package Model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import java.time.format.DateTimeFormatter;


public class Enrollment {

    @EmbeddedId
    private EnrollmentId id;

   
    private User student;


    private Course course;

    private LocalDateTime enrollmentDate;


    private String status;

    // Constructors, Getters, and Setters
    public Enrollment() { 
    }

    public Enrollment(User student, Course course, LocalDateTime enrollmentDate, String status) {
        this.id = new EnrollmentId(student.getId(), course.getIdCourse());
        this.student = student;
        this.course = course;
        this.enrollmentDate = enrollmentDate;
        this.status = status;
    }

    public EnrollmentId getId() {
        return id;
    }
    public void setId(EnrollmentId id) {
        this.id = id;
    }
    public User getStudent() {
        return student;
    }
    public void setStudent(User student) {
        this.student = student;
    }
    public Course getCourse() {
        return course;
    }
    public void setCourse(Course course) {
        this.course = course;
    }
    public LocalDateTime getEnrollmentDate() {
        return enrollmentDate;
    }
    public void setEnrollmentDate(LocalDateTime enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getFormattedEnrollmentDate() {
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    return this.enrollmentDate.format(formatter);
}

}