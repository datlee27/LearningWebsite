package DAO;

import Model.Assignment;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import Model.Submission;
import Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

public class SubmissionDAO {
    private final DBcontext dbContext = new DBcontext();

public List<Submission> getSubmissionsBeforeDueDate(int assignmentId, Date dueDate) throws SQLException, Exception {
    List<Submission> list = new ArrayList<>();
    String sql = "SELECT * FROM learning_management.Submissions WHERE assignment_id = ? AND submission_date < ?;";
    System.out.println("Executing query for assignmentId: " + assignmentId + ", dueDate: " + dueDate);
    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, assignmentId);
        ps.setTimestamp(2, new Timestamp(dueDate.getTime()));
        ResultSet rs = ps.executeQuery();
        AssignmentDAO assignmentDAO = new AssignmentDAO(); // Add AssignmentDAO
        while (rs.next()) {
            Submission s = new Submission();
            s.setId(rs.getInt("id"));
            s.setFileUrl(rs.getString("file_url"));
            s.setSubmissionDate(rs.getTimestamp("submission_date").toLocalDateTime());
            s.setGrade(rs.getDouble("grade"));

            int studentId = rs.getInt("student_id");
            User student = new UserDAO().getUserById(studentId);
            if (student != null) {
                s.setStudent(student);
            } else {
                System.out.println("Warning: No student found for studentId: " + studentId);
                s.setStudent(new User());
            }

            // Set the assignment
            Assignment assignment = assignmentDAO.getAssignmentById(assignmentId); // Fetch assignment
            if (assignment != null) {
                s.setAssignment(assignment);
            } else {
                System.out.println("Warning: No assignment found for assignmentId: " + assignmentId);
                s.setAssignment(new Assignment(0, 0, "", "", null, "")); // Default assignment
            }

            list.add(s);
            System.out.println("Found submission: ID=" + s.getId() + ", Student=" + (student != null ? student.getFirstName() : "null"));
        }
    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
        throw e;
    } catch (Exception e) {
        System.out.println("General Error: " + e.getMessage());
        throw e;
    }
    System.out.println("Total submissions found: " + list.size());
    return list;
}

    public void updateGrade(int submissionId, double grade) throws SQLException, Exception {
        String sql = "UPDATE learning_management.Submissions SET grade = ? WHERE id = ?;";
        System.out.println("Updating grade for submissionId: " + submissionId + " to " + grade);
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, grade);
            ps.setInt(2, submissionId);
            ps.executeUpdate();
        }
    }
}