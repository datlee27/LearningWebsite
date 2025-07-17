
package Model;

import com.google.api.client.util.DateTime;

public class Assignment {
    private int idAss, idCourse;
    private Integer idLecture;
    private String title, description;
    private DateTime dueDate;
    private String status;

    public Assignment(int idCourse, Integer idLecture, String title, String description, DateTime dueDate, String status) {
        this.idCourse = idCourse;
        this.idLecture = idLecture;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getIdAss() {
        return idAss;
    }

    public void setIdAss(int idAss) {
        this.idAss = idAss;
    }

    public int getIdCourse() {
        return idCourse;
    }

    public void setIdCourse(int idCourse) {
        this.idCourse = idCourse;
    }

    public Integer getIdLecture() {
        return idLecture;
    }

    public void setIdLecture(Integer idLecture) {
        this.idLecture = idLecture;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public DateTime getDueDate() {
        return dueDate;
    }

    public void setDueDate(DateTime dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    public java.util.Date getDueDateAsJavaUtilDate() {
    return new java.util.Date(dueDate.getValue());
    }

    @Override
    public String toString() {
        return "Assignments{" +
               "idAss=" + idAss +
               ", idCourse=" + idCourse +
               ", idLecture=" + idLecture +
               ", title=" + title +
               ", description=" + description +
               ", dueDate=" + dueDate +
               ", status=" + status +
               '}';
    }
}
