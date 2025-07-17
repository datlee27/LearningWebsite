package DAO;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import Model.Submission;

public class SubmissionDAO {

    private static final Logger logger = Logger.getLogger(SubmissionDAO.class.getName());

    /**
     * Saves a new submission record to the database.
     *
     * @param submission The Submission object to persist.
     * @return The saved Submission object.
     */
    public Submission saveSubmission(Submission submission) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.persist(submission);
            transaction.commit();
            logger.info("Successfully saved submission for assignment ID: " + submission.getAssignment().getIdAss());
            return submission;
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            logger.log(Level.SEVERE, "Error saving submission", e);
            throw new RuntimeException("Failed to save submission", e);
        } finally {
            em.close();
        }
    }

    /**
     * Updates a submission, typically for grading.
     *
     * @param submission The Submission object with updated data (e.g., a grade).
     */
    public void updateSubmission(Submission submission) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.merge(submission);
            transaction.commit();
            logger.info("Successfully updated submission ID: " + submission.getId());
        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            logger.log(Level.SEVERE, "Error updating submission ID: " + submission.getId(), e);
            throw new RuntimeException("Failed to update submission", e);
        } finally {
            em.close();
        }
    }

    /**
     * Retrieves a submission by its unique ID.
     *
     * @param submissionId The ID of the submission.
     * @return An Optional containing the submission if found.
     */
    public Optional<Submission> findSubmissionById(int submissionId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Submission.class, submissionId));
        } finally {
            em.close();
        }
    }

    /**
     * Retrieves all submissions for a specific assignment.
     *
     * @param assignmentId The ID of the assignment.
     * @return A list of submissions.
     */
    public List<Submission> getSubmissionsByAssignment(int assignmentId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Submission> query = em.createQuery(
                "SELECT s FROM Submission s WHERE s.assignment.idAss = :assignmentId",
                Submission.class
            );
            query.setParameter("assignmentId", assignmentId);
            return query.getResultList();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error retrieving submissions for assignment ID: " + assignmentId, e);
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }
}