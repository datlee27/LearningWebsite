package Model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.util.Date;


public class Submission{
    private int id;

    private Assignment assignment;

    
    private User student;

  
    private String fileUrl;

   
    private LocalDateTime submissionDate;

   
    private Double grade;

    public Submission() {
    }

    // Constructor updated for object relationships
    public Submission(Assignment assignment, User student, String fileUrl, LocalDateTime submissionDate) {
        this.assignment = assignment;
        this.student = student;
        this.fileUrl = fileUrl;
        this.submissionDate = submissionDate;
    }

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public void setAssignment(Assignment assignment) {
        this.assignment = assignment;
    }

    public User getStudent() {
        return student;
    }

    public void setStudent(User student) {
        this.student = student;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public LocalDateTime getSubmissionDate() {
        return submissionDate;
    }

    public void setSubmissionDate(LocalDateTime submissionDate) {
        this.submissionDate = submissionDate;
    }

    public Double getGrade() {
        return grade;
    }

    public void setGrade(Double grade) {
        this.grade = grade;
    }
    public Date getSubmissionDateAsDate() {
        if (submissionDate != null) {
            return Date.from(submissionDate.atZone(java.time.ZoneId.systemDefault()).toInstant());
        }
        return null;
    }
}