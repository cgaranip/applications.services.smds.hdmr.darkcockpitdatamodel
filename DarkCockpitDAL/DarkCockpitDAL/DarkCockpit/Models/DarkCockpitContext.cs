using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace DarkCockpitDAL.DarkCockpit.Models
{
    public partial class DarkCockpitContext : DbContext
    {
        public virtual DbSet<ApplicationRole> ApplicationRole { get; set; }
        public virtual DbSet<ApplicationStatusType> ApplicationStatusType { get; set; }
        public virtual DbSet<ApplicationUser> ApplicationUser { get; set; }
        public virtual DbSet<ApplicationUserRole> ApplicationUserRole { get; set; }
        public virtual DbSet<DataMqttTrackerLog> DataMqttTrackerLog { get; set; }
        public virtual DbSet<RefFlowStrategyDefinition> RefFlowStrategyDefinition { get; set; }
        public virtual DbSet<RefFlowStrategyTopicRoleEmail> RefFlowStrategyTopicRoleEmail { get; set; }
        public virtual DbSet<RefWorkFlowDefinition> RefWorkFlowDefinition { get; set; }
        public virtual DbSet<SchemaMigrations> SchemaMigrations { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseSqlServer(@"Data Source=AZSCTSsqlserver.amr.corp.intel.com;Initial Catalog=DarkCockpit;Integrated Security=SSPI;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ApplicationRole>(entity =>
            {
                entity.HasKey(e => e.RoleId);

                entity.Property(e => e.RoleId).HasColumnName("RoleID");

                entity.Property(e => e.RoleDescription)
                    .IsRequired()
                    .HasMaxLength(250)
                    .IsUnicode(false);

                entity.Property(e => e.RoleDisplayName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.RoleName)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.RootTopic)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ApplicationStatusType>(entity =>
            {
                entity.HasKey(e => e.StatusId);

                entity.Property(e => e.StatusId).HasColumnName("StatusID");

                entity.Property(e => e.StatusName)
                    .IsRequired()
                    .HasMaxLength(20)
                    .IsUnicode(false);
            });

            modelBuilder.Entity<ApplicationUser>(entity =>
            {
                entity.HasKey(e => e.LoginId);

                entity.HasIndex(e => e.UserId)
                    .HasName("IX_ApplicationUser")
                    .IsUnique();

                entity.Property(e => e.LoginId)
                    .HasColumnName("LoginID")
                    .HasMaxLength(100)
                    .IsUnicode(false)
                    .ValueGeneratedNever();

                entity.Property(e => e.CreationDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FirstName)
                    .IsRequired()
                    .HasMaxLength(100)
                    .IsUnicode(false);

                entity.Property(e => e.FullName)
                    .IsRequired()
                    .HasMaxLength(150)
                    .IsUnicode(false);

                entity.Property(e => e.LastLoginDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.LastName)
                    .IsRequired()
                    .HasMaxLength(50)
                    .IsUnicode(false);

                entity.Property(e => e.ModifiedDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.StatusId).HasColumnName("StatusID");

                entity.Property(e => e.UserId)
                    .HasColumnName("UserID")
                    .ValueGeneratedOnAdd();

                entity.Property(e => e.Wwid).HasColumnName("WWID");

                entity.HasOne(d => d.Status)
                    .WithMany(p => p.ApplicationUser)
                    .HasForeignKey(d => d.StatusId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ApplicationUser_ApplicationStatusType");
            });

            modelBuilder.Entity<ApplicationUserRole>(entity =>
            {
                entity.Property(e => e.ApplicationUserRoleId).HasColumnName("ApplicationUserRoleID");

                entity.Property(e => e.ModifiedDate)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.RoleId).HasColumnName("RoleID");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.ApplicationUserRole)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ApplicationUserRole_ApplicationRole");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.ApplicationUserRole)
                    .HasPrincipalKey(p => p.UserId)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ApplicationUserRole_ApplicationUser");
            });

            modelBuilder.Entity<DataMqttTrackerLog>(entity =>
            {
                entity.HasKey(e => e.MqttTrackerId);

                entity.Property(e => e.ClientId)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.Property(e => e.ClientType)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.CreatedBy)
                    .HasMaxLength(255)
                    .IsUnicode(false);

                entity.Property(e => e.CreatedOn).HasColumnType("datetime");

                entity.Property(e => e.Message)
                    .IsRequired()
                    .HasMaxLength(1000);

                entity.Property(e => e.RootTopic)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Topic).HasMaxLength(250);
            });

            modelBuilder.Entity<RefFlowStrategyDefinition>(entity =>
            {
                entity.HasKey(e => new { e.WorkFlowId, e.SubscriptionTopic });

                entity.Property(e => e.WorkFlowId).HasDefaultValueSql("((1))");

                entity.Property(e => e.SubscriptionTopic).HasMaxLength(250);

                entity.Property(e => e.ActionUrl)
                    .HasColumnName("ActionURL")
                    .HasMaxLength(1000);

                entity.Property(e => e.ActionUrlargsJson)
                    .HasColumnName("ActionURLArgsJSON")
                    .HasMaxLength(1000);

                entity.Property(e => e.CreatedBy)
                    .IsRequired()
                    .HasMaxLength(255)
                    .HasDefaultValueSql("(N'system')");

                entity.Property(e => e.CreatedOn)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.Property(e => e.FlowStrategyId).ValueGeneratedOnAdd();

                entity.Property(e => e.PublishTopic)
                    .IsRequired()
                    .HasMaxLength(250);

                entity.Property(e => e.StrategyDefinitionClass)
                    .IsRequired()
                    .HasMaxLength(1000)
                    .HasDefaultValueSql("(N'DarkCockpitWebAPIMain.FlowStrategy.BaseFlowStrategy')");
            });

            modelBuilder.Entity<RefFlowStrategyTopicRoleEmail>(entity =>
            {
                entity.HasKey(e => new { e.WorkFlowId, e.SubscriptionTopic, e.RoleId });

                entity.Property(e => e.WorkFlowId).HasDefaultValueSql("((1))");

                entity.Property(e => e.SubscriptionTopic).HasMaxLength(250);

                entity.Property(e => e.RoleId).HasColumnName("RoleID");

                entity.Property(e => e.CreatedBy)
                    .IsRequired()
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .HasDefaultValueSql("('system')");

                entity.Property(e => e.CreatedOn)
                    .HasColumnType("datetime")
                    .HasDefaultValueSql("(getutcdate())");

                entity.HasOne(d => d.Role)
                    .WithMany(p => p.RefFlowStrategyTopicRoleEmail)
                    .HasForeignKey(d => d.RoleId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_RefFlowStrategyTopicRoleEmail_ApplicationRole");
            });

            modelBuilder.Entity<RefWorkFlowDefinition>(entity =>
            {
                entity.HasKey(e => new { e.RootTopic, e.WorkflowName });

                entity.Property(e => e.RootTopic).HasMaxLength(50);

                entity.Property(e => e.WorkflowName).HasMaxLength(250);

                entity.Property(e => e.WorkflowId).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<SchemaMigrations>(entity =>
            {
                entity.HasKey(e => e.SchemaMigrationNumber);

                entity.Property(e => e.SchemaMigrationNumber)
                    .HasMaxLength(255)
                    .IsUnicode(false)
                    .ValueGeneratedNever();
            });
        }
    }
}
