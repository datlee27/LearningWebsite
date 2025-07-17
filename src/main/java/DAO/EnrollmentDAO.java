package DAO;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;

import Model.Enrollment;

public class EnrollmentDAO {
    
    public void save(Enrollment enrollment) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.persist(enrollment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            throw new RuntimeException("Could not save enrollment", e);
        } finally {
            em.close();
        }
    }
    public void update(Enrollment enrollment) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.merge(enrollment);
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            throw new RuntimeException("Could not update enrollment", e);
        } finally {
            em.close();
        }
    }
    
    public Enrollment findById(int id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Enrollment.class, id);
        } finally {
            em.close();
        }
    }

    public List<Enrollment> findByCourseId(int courseId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Enrollment> query = em.createQuery("SELECT e FROM Enrollment e WHERE e.course.id = :courseId", Enrollment.class);
            query.setParameter("courseId", courseId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }



    public void delete(Enrollment enrollment) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction transaction = em.getTransaction();
        try {
            transaction.begin();
            em.remove(em.contains(enrollment) ? enrollment : em.merge(enrollment));
            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            throw new RuntimeException("Could not delete enrollment", e);
        } finally {
            em.close();
        }
    }
} 