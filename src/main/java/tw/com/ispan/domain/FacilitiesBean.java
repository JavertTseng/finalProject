package tw.com.ispan.domain;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "facilities")
public class FacilitiesBean {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "facility_id")
	private Integer facilityId;

	@Column(name = "community_id")
	private Integer communityId;

	@Column(name = "facility_name")
	private String facilityName;

	@Column(name = "max_users")
	private Integer maxUsers;

	@Column(name = "facility_description")
	private String facilityDescription;

	@Column(name = "facility_location")
	private String facilityLocation;

	@Column(name = "open_time")
	private LocalTime openTime;

	@Column(name = "close_time")
	private LocalTime closeTime;

	@Column(name = "reservable_duration")
	private Integer reservableDuration;

	@Column(name = "fee")
	private Integer fee;

	@Column(name = "facility_status")
	private String facilityStatus;

	@Column(name = "created_at")
	private LocalDateTime createdAt;

	@Column(name = "updated_at")
	private LocalDateTime updatedAt;
	
	@OneToMany(mappedBy = "facility", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JsonManagedReference
	private List<FacilitesImagesBean> images;
	
	
	public List<FacilitesImagesBean> getImages() {
		return images;
	}

	public void setImages(List<FacilitesImagesBean> images) {
		this.images = images;
	}

	@Override
	public String toString() {
	    return "FacilitiesBean [facilityId=" + facilityId 
	        + ", communityId=" + communityId 
	        + ", facilityName=" + facilityName 
	        + ", maxUsers=" + maxUsers 
	        + ", facilityDescription=" + facilityDescription 
	        + ", facilityLocation=" + facilityLocation 
	        + ", openTime=" + openTime 
	        + ", closeTime=" + closeTime 
	        + ", reservableDuration=" + reservableDuration 
	        + ", fee=" + fee 
	        + ", facilityStatus=" + facilityStatus 
	        + ", createdAt=" + createdAt 
	        + ", updatedAt=" + updatedAt 
	        + ", imageCount=" + (images != null ? images.size() : 0) 
	        + "]";
	}

	public Integer getFacilityId() {
		return facilityId;
	}

	public void setFacilityId(Integer facilityId) {
		this.facilityId = facilityId;
	}

	public Integer getCommunityId() {
		return communityId;
	}

	public void setCommunityId(Integer communityId) {
		this.communityId = communityId;
	}

	public String getFacilityName() {
		return facilityName;
	}

	public void setFacilityName(String facilityName) {
		this.facilityName = facilityName;
	}

	public Integer getMaxUsers() {
		return maxUsers;
	}

	public void setMaxUsers(Integer maxUsers) {
		this.maxUsers = maxUsers;
	}

	public String getFacilityDescription() {
		return facilityDescription;
	}

	public void setFacilityDescription(String facilityDescription) {
		this.facilityDescription = facilityDescription;
	}

	public String getFacilityLocation() {
		return facilityLocation;
	}

	public void setFacilityLocation(String facilityLocation) {
		this.facilityLocation = facilityLocation;
	}

	public LocalTime getOpenTime() {
		return openTime;
	}

	public void setOpenTime(LocalTime openTime) {
		this.openTime = openTime;
	}

	public LocalTime getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(LocalTime closeTime) {
		this.closeTime = closeTime;
	}

	public Integer getReservableDuration() {
		return reservableDuration;
	}

	public void setReservableDuration(Integer reservableDuration) {
		this.reservableDuration = reservableDuration;
	}

	public Integer getFee() {
		return fee;
	}

	public void setFee(Integer fee) {
		this.fee = fee;
	}

	public String getFacilityStatus() {
		return facilityStatus;
	}

	public void setFacilityStatus(String facilityStatus) {
		this.facilityStatus = facilityStatus;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

}
