package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {

    // The name "learning-management-unit" must match the name defined in your persistence.xml
    private static final String PERSISTENCE_UNIT_NAME = "learning-management-unit";
    private static EntityManagerFactory factory;

    /**
     * Creates and returns the singleton EntityManagerFactory instance.
     * @return A singleton EntityManagerFactory instance.
     */
    public static EntityManagerFactory getEntityManagerFactory() {
        if (factory == null) {
            factory = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
        }
        return factory;
    }

    /**
     * Creates and returns a new EntityManager from the factory.
     * @return A new EntityManager instance.
     */
    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }


    /**
     * Closes the EntityManagerFactory to release all resources.
     * Should be called when the application is shutting down.
     */
    public static void shutdown() {
        if (factory != null) {
            factory.close();
        }
    }
}