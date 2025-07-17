package Model;

import java.io.Serializable;

import jakarta.persistence.Column;

public class EnrollmentId implements Serializable {

    @Column(name = "student_id")
    private int studentId;
    
    @Column(name = "course_id")
    private int courseId;

    public EnrollmentId() {
    }

    public EnrollmentId(int studentId, int courseId) {
        this.studentId = studentId;
        this.courseId = courseId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EnrollmentId that = (EnrollmentId) o;
        return studentId == that.studentId &&
               courseId == that.courseId;
    }

    @Override
    public int hashCode() {
        int result = studentId;
        result = 31 * result + courseId;
        return result;
    }
}